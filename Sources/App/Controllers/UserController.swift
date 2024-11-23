//
//  Untitled.swift
//  vapor-admin
//
//  Created by Jimmy Hough Jr on 11/22/24.
//

import Vapor

struct UserController: RouteCollection {
    
    func boot(routes: any RoutesBuilder) throws {
        routes.post("register", use: register)
        routes.post("login", use: login)
    }
    
    @Sendable func register(_ req: Request)  async throws -> Response {
        return .init(status: .notImplemented)
    }
    
    @Sendable func login(_ req: Request) async throws -> Response {
        return .init(status: .notImplemented)
    }
}
