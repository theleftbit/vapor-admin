@testable import App
import Fluent
import XCTVapor
import Crypto

final class ResetPasswordTests: XCTestCase {
    var app: Application!
    var testWorld: TestWorld!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        self.testWorld = try TestWorld(app: app)
    }
    
    override func tearDown() {
        app.shutdown()
    }
    
    func testResetPassword() async throws {
        app.randomGenerators.use(.rigged(value: "passwordtoken"))
        
        let user = User(fullName: "Test User", email: "test@test.com", passwordHash: "123")
        try await app.repositories.users.create(user)
        
        let resetPasswordRequest = ResetPasswordRequest(email: "test@test.com")
        try await app.test(.POST, "api/auth/reset-password", content: resetPasswordRequest, afterResponse: { res in
            XCTAssertEqual(res.status, .noContent)
            let passwordToken = try await app.repositories.passwordTokens.find(token: SHA256.hash("passwordtoken"))
            XCTAssertNotNil(passwordToken)
            
            guard let resetPasswordJob =  app.queues.test.first(EmailJob.self) else {
                XCTFail("Need the job to check.")
                return 
            }
            XCTAssertEqual(resetPasswordJob.recipient, "test@test.com")
            XCTAssertEqual(resetPasswordJob.email.templateName, "reset_password")
            XCTAssertEqual(resetPasswordJob.email.templateData["reset_url"], "http://frontend.local/auth/reset-password?token=passwordtoken")
        })
    }
    
    func testResetPasswordSucceedsWithNonExistingEmail() async  throws {
        let resetPasswordRequest = ResetPasswordRequest(email: "none@test.com")
        
        try await app.test(.POST, "api/auth/reset-password",
                           content: resetPasswordRequest,
                           afterResponse: { res in
            XCTAssertEqual(res.status, .noContent)
            let tokenCount = try await  app.repositories.passwordTokens.count()
            XCTAssertFalse(app.queues.test.contains(EmailJob.self))
            XCTAssertEqual(tokenCount, 0)
        })
    }
    
    func testRecoverAccount() async throws {
        let user = User(fullName: "Test User", email: "test@test.com", passwordHash: "oldpassword")
        try await app.repositories.users.create(user)
        let token = try PasswordToken(userID: user.requireID(), token: SHA256.hash("passwordtoken"))
        let existingToken = try PasswordToken(userID: user.requireID(), token: "token2")
        
        try await app.repositories.passwordTokens.create(token)
        try await app.repositories.passwordTokens.create(existingToken)
        
        let recoverRequest = RecoverAccountRequest(password: "newpassword", confirmPassword: "newpassword", token: "passwordtoken")
        
        try await app.test(.POST, "api/auth/recover", content: recoverRequest, afterResponse: { res in
            XCTAssertEqual(res.status, .noContent)
            let user = try await app.repositories.users.find(id: user.requireID())!
            try XCTAssertTrue(BCryptDigest().verify("newpassword", created: user.passwordHash))
            let count = try await app.repositories.passwordTokens.count()
            XCTAssertEqual(count, 0)
        })
    }
    
    func testRecoverAccountWithExpiredTokenFails() async throws {
        let token = PasswordToken(userID: UUID(), token: SHA256.hash("passwordtoken"), expiresAt: Date().addingTimeInterval(-60))
        try await app.repositories.passwordTokens.create(token)
        
        let recoverRequest = RecoverAccountRequest(password: "password", confirmPassword: "password", token: "passwordtoken")
        try await app.test(.POST, "api/auth/recover", content: recoverRequest, afterResponse: { res in
            XCTAssertResponseError(res, AuthenticationError.passwordTokenHasExpired)
        })
    }
    
    func testRecoverAccountWithInvalidTokenFails() async throws {
        let recoverRequest = RecoverAccountRequest(password: "password", confirmPassword: "password", token: "sdfsdfsf")
        try await app.test(.POST, "api/auth/recover", content: recoverRequest, afterResponse: { res in
            XCTAssertResponseError(res, AuthenticationError.invalidPasswordToken)
        })
    }
    
    func testRecoverAccountWithNonMatchingPasswordsFail() async throws {
        let recoverRequest = RecoverAccountRequest(password: "password", confirmPassword: "password123", token: "token")
        try await app.test(.POST, "api/auth/recover", content: recoverRequest, afterResponse: { res in
            XCTAssertResponseError(res, AuthenticationError.passwordsDontMatch)
        })
    }
    
    func testVerifyPasswordToken() async throws {
        let user = User(fullName: "Test User", email: "test@test.com", passwordHash: "123")
        try await app.repositories.users.create(user)
        let passwordToken = try PasswordToken(userID: user.requireID(), token: SHA256.hash("token"))
        try await app.repositories.passwordTokens.create(passwordToken)
        
        try app.test(.GET, "api/auth/reset-password/verify?token=token", afterResponse: { res in
            XCTAssertEqual(res.status, .noContent)
        })
    }
    
    func testVerifyPasswordTokenFailsWithInvalidToken() throws {
        try app.test(.GET, "api/auth/reset-password/verify?token=invalidtoken", afterResponse: { res in
            XCTAssertResponseError(res, AuthenticationError.invalidPasswordToken)
        })
    }
    
    func testVerifyPasswordTokenFailsWithExpiredToken() async throws {
        let user = User(fullName: "Test User", email: "test@test.com", passwordHash: "123")
        try await app.repositories.users.create(user)
        let passwordToken = try PasswordToken(userID: user.requireID(), token: SHA256.hash("token"), expiresAt: Date().addingTimeInterval(-60))
        try await app.repositories.passwordTokens.create(passwordToken)
        
        try await app.test(.GET, "api/auth/reset-password/verify?token=token", afterResponse: { res in
            XCTAssertResponseError(res, AuthenticationError.passwordTokenHasExpired)
            let tokenCount = try await app.repositories.passwordTokens.count()
            XCTAssertEqual(tokenCount, 0)
        })
    }
}
