// The Swift Programming Language
// https://docs.swift.org/swift-book

import Vapor

public class VaporAdmin {
    static public func banner() -> String {
        """
        Vapor Admin
        """
    }
    
    
    static public func confgiureDB() throws {
        
    }
    
    static public func adminRoutes(for app: Vapor.Application) throws {
        app.get("admin") { req async -> String in
            VaporAdmin.banner()
        }
    }
    
}
