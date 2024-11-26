import Vapor

func services(_ app: Application) throws {
    app.logger.info("Configuring services ...")
    app.randomGenerators.use(.random)
    app.repositories.use(.database)
}
