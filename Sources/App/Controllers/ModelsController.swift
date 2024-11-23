//
//  Untitled.swift
//  vapor-admin
//
//  Created by Jimmy Hough Jr on 11/22/24.
//

import Vapor

struct ModelsController: RouteCollection {
    
    func boot(routes: any RoutesBuilder) throws {
        
        routes.group("models") { auth in
            
        }
    }
}
