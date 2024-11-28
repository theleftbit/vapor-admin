// The Swift Programming Language
// https://docs.swift.org/swift-book

import Vapor

public class VaporAdmin {
    static public func banner() -> String {
        """
        Vapor Admin
        """
    }
    
    static public func confgiureDB(for app: Vapor.Application) throws {
        app.logger.info("configuring admin db")
        // run migrations for admin user db
        // run migrations for acls?
    }
    
    static public func adminAPIRoutes(for app: Vapor.Application) throws {
        app.get("admin", "api") { req async -> String in
              """
              Vapor Admin API
              """
        }
    }
    
    static public func adminRoutes(for app: Vapor.Application) throws {
        app.get("admin") { req async -> String in
            VaporAdmin.banner()
        }
    }
    
}
