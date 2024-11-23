//
//  UserAuthenticator.swift
//  vapor-admin
//
//  Created by Jimmy Hough Jr on 11/22/24.
//

import Vapor

struct UserAuthenticator: AsyncBasicAuthenticator {
    typealias User = App.User
    
    func authenticate(
        basic: BasicAuthorization,
        for request: Request
    ) async throws {
      
    }
}
