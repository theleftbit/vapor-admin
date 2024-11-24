//
//  GeneralTests.swift
//  
//
//  Created by Jimmy Hough Jr on 11/29/23.
//

import XCTest
import XCTVapor

final class GeneralTests: XCTestCase {
    var app: Application!

    
    override func setUpWithError() throws {
        app = Application(.testing)
        if app.environment == .testing {
           
        }

    }
    
    override func tearDownWithError() throws {
        Task {
            try await app.autoRevert()
            app.shutdown()
        }
    }
    
    func testEnvFileExists() throws {
        let hasFile = !FileManager.default.fileExists(atPath: "./.env" + Environment.testing.name)
        XCTAssertTrue(hasFile, ".env." + app.environment.name + " should exist to use the template.")
    }

}
