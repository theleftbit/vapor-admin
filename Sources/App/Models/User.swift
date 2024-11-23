//
//  User.swift
//  vapor-admin
//
//  Created by Jimmy Hough Jr on 11/22/24.
//

import Vapor
import Fluent

final class User: Model, Authenticatable, @unchecked Sendable  {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    init() {}
    
    init(
        id: UUID? = nil,
        fullName: String,
        email: String,
        passwordHash: String
    ) {
        self.id = id
        
        self.email = email
        self.passwordHash = passwordHash
    }
}


 
