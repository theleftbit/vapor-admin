// The Swift Programming Language
// https://docs.swift.org/swift-book

import Vapor
import Fluent
import FluentPostgresDriver

import Foundation
import FluentKit

extension DatabaseID {
    public static var vaporAdminDB: DatabaseID {
        .init(string: "vapor-admin-db")
    }
}

public class VaporAdmin {
    static public func banner() -> String {
        """
        Vapor Admin
        """
    }
    
    static public func confgiureDB(for app: Vapor.Application) throws {
        app.logger.info("configuring admin db...")
        
        app.databases.use(
            .postgres(
                configuration: .init(
                    hostname: "localhost",
                    username: "vaporadmin",
                    password: "vaporadminpassword",
                    database: "vaporadmindatabase", /*app.db*/
                    tls: .disable
                )
            ),
            as: .vaporAdminDB
        )
        app.logger.info("configured admin db.")
        
        app.migrations.add(AdminUser.migration(.one))
        app.logger.info("added admin user migration.")
    }
    
    static public func addAdminAPIRoutes(to app: Vapor.Application) throws {
        
        app.get("admin", "api") { req async -> String in
              """
              Vapor Admin API
              """
        }
        app.logger.info("admin api routes added.")
    }
    
    static public func addAdminRoutes(to app: Vapor.Application) throws {
        
        app.get("admin") { req async -> String in
            VaporAdmin.banner()
        }
        app.logger.info("admin routes added.")
    }
    
    public final class AdminUser: Model, @unchecked Sendable {
        static public let schema = "VaporAdminUser"
        // Unique identifier for this Planet.
        @ID(key: .id)
        public var id: UUID?
        
        // The Planet's name.
        @Field(key: "name")
        public var name: String
        
        
        @Timestamp(key: "created_at", on: .create)
        public var createdAt: Date?
        
        // When this Planet was last updated.
        @Timestamp(key: "updated_at", on: .update)
        public var updatedAt: Date?
        
        // Creates a new, empty Planet.
        public init() { }
        
        // Creates a new Planet with all properties set.
        public init(id: UUID? = nil, name: String) {
            self.id = id
            self.name = name
        }
    }
    
   
}
public extension VaporAdmin.AdminUser {
    
    enum Migrations {
        case one
    }
    
    struct Migration1: AsyncMigration {
        public func prepare(on database: Database) async throws {
            // Make a change to the database.
            
        }
        
        public func revert(on database: Database) async throws {
            // Undo the change made in `prepare`, if possible.
        }
    }

    static func migration(_ number: Migrations) -> Fluent.AsyncMigration {
        switch number {
        case .one:
            return Migration1()
        }
    }
}
