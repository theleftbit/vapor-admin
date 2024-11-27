import Vapor
import Fluent
import struct Foundation.UUID

// The Swift Programming Language
// https://docs.swift.org/swift-book
public struct VaporAdmin {
    public static func banner() -> String {
        "Hello Vapor Admin!"
    }
    
    public static func configure(for app: Vapor.Application) async throws {
        
    }
}
