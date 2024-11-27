import Vapor

func migrations(_ app: Application) throws {
    app.logger.info("Configuring Migrations.")
    // Initial Migrations
    app.migrations.add(CreateUser())
    app.migrations.add(CreateRefreshToken())
    app.migrations.add(CreateEmailToken())
    app.migrations.add(CreatePasswordToken())
}
