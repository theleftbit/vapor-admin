import Fluent
import Vapor

extension VaporAdmin {
    
    public static func registerRoutes(for app:V apor.Application) {
        try route(for: app)
    }
    
    func routes(_ app: Application) throws {
        app.logger.info("Configuring routes...")
        app.group("api") { api in
            // Authentication
            try! api.register(collection: AuthenticationController())
        }
    }
}
