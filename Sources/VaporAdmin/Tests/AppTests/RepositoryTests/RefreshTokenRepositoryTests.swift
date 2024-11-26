@testable import App
import Fluent
import XCTVapor

final class RefreshTokenRepositoryTests: XCTestCase {
    var app: Application!
    var repository: RefreshTokenRepository!
    var user: User!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        repository = DatabaseRefreshTokenRepository(database: app.db)
        try app.autoMigrate().wait()
        user = User(fullName: "Test User", email: "test@test.com", passwordHash: "123")
    }
    
    override func tearDownWithError() throws {
        try app.migrator.revertAllBatches().wait()
        app.shutdown()
    }
    
    func testCreatingToken() async throws {
        try await user.create(on: app.db)
        let token = try RefreshToken(token: "123", userID: user.requireID())
        try await repository.create(token)
        
        XCTAssertNotNil(token.id)
        
        let tokenRetrieved = try await RefreshToken.find(token.id, on: app.db)
        XCTAssertNotNil(tokenRetrieved)
        XCTAssertEqual(tokenRetrieved!.$user.id, try user.requireID())
    }
    
    func testFindingTokenById() async throws {
        try await user.create(on: app.db)
        let token = try RefreshToken(token: "123", userID: user.requireID())
        try await token.create(on: app.db)
        let tokenId = try token.requireID()
        let tokenFound = try await  repository.find(id: tokenId)
        XCTAssertNotNil(tokenFound)
    }
    
    // TODO: Requires to reset the middleware of the database... so lets do that when my PR gets merged.
    func testFindingTokenByTokenString() async throws {
        try await user.create(on: app.db)
        let token = try RefreshToken(token: "123", userID: user.requireID())
        try await token.create(on: app.db)
        let tokenFound = try await repository.find(token: "123")
        XCTAssertNotNil(tokenFound)
    }
    
    func testDeletingToken() async throws {
        try await  user.create(on: app.db)
        let token = try RefreshToken(token: "123", userID: user.requireID())
        try await token.create(on: app.db)
        let tokenCount = try await RefreshToken.query(on: app.db).count()
        XCTAssertEqual(tokenCount, 1, "Need to create a token to test delete.")
        try await repository.delete(token)
        let newTokenCount = try await  RefreshToken.query(on: app.db).count()
        XCTAssertEqual(newTokenCount, 0, "Created token should have been deleted.")
    }
    
    func testGetCount() async throws {
        try await user.create(on: app.db)
        let token = try RefreshToken(token: "123", userID: user.requireID())
        try await token.create(on: app.db)
        let tokenCount = try await repository.count()
        XCTAssertEqual(tokenCount, 1)
    }
}
    

