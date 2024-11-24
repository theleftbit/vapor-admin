import Fluent
import FluentPostgresDriver
import Vapor
import JWT
import Mailgun
import QueuesRedisDriver

public func configure(_ app: Application) throws {
    app.logger.info("configuring app...")
    
    app.logger.info("Setting up JWT")
    
    // MARK: JWT
    if app.environment != .testing {
        let jwksFilePath = app.directory.workingDirectory + (Environment.get("JWKS_KEYPAIR_FILE") ?? "keypair.jwks")
        app.logger.info("Looking for JWKS @ \(jwksFilePath)")
         guard
             let jwks = FileManager.default.contents(atPath: jwksFilePath),
             let jwksString = String(data: jwks, encoding: .utf8)
             else {
                 fatalError("Failed to load JWKS Keypair file at: \(jwksFilePath)")
         }
         try app.jwt.signers.use(jwksJSON: jwksString)
    }else {
        app.logger.notice("Testing env not using JWT signing.")
    }
    app.logger.info("Setting up DB....")
    // MARK: Database
    try configurePostgresDatabase(for: app)
   
    app.logger.info("Setting up middleware...")
    // MARK: Middleware
    app.middleware = .init()
    app.middleware.use(ErrorMiddleware.custom(environment: app.environment))
    app.middleware.use(app.sessions.middleware)

    // MARK: Model Middleware
    
    app.logger.info("Setting up Mailgun...")
    // MARK: Mailgun
    app.mailgun.configuration = .environment
    app.mailgun.defaultDomain = .sandbox
    app.logger.info("Mailgun default domain: \(app.mailgun.defaultDomain ?? MailgunDomain.sandbox)")

    app.logger.info("Configuring app from env...")
    // MARK: App Config
    app.config = .environment
    
    /// MARK Final Setup
    try routes(app)
    try migrations(app)
    try queues(app)
    try services(app)
      
    if app.environment == .development {
        app.logger.info("automigrating db...")
        try app.autoMigrate().wait()
        app.logger.info("config:  \(app.queues.configuration)")
//        try app.queues.startInProcessJobs()
    }else {
        // could check for a queues process maybe
        let msg =
          """
          Queues in production should be ran in another processs.
            try 'swift run App queues'
          """
        app.logger.info(.init(stringLiteral: msg))
    }
    
}

private func configurePostgresDatabase(for app: Application) throws {
    
    let hostname = Environment.get("POSTGRES_HOSTNAME") ?? "localhost"
    let username = Environment.get("POSTGRES_USERNAME") ?? "vapor"
    let password = Environment.get("POSTGRES_PASSWORD") ?? "password"
    let database = Environment.get("POSTGRES_DATABASE") ?? "vapor"
    
    var conf = SQLPostgresConfiguration(hostname: hostname,
                                        username: username,
                                        tls: .disable)
    conf.coreConfiguration.database = database
    conf.coreConfiguration.password = password
    
    app.databases.use(.postgres(configuration: conf,
                                decodingContext: .default),
                      as: .psql)
    app.logger.info("DB \(database) on \(hostname) as \(username).")
}
