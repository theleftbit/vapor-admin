@testable import App
import Fluent
import XCTVapor

final class PasswordTokenRepositoryTests: XCTestCase {
    var app: Application!
    var repository: PasswordTokenRepository!
    var user: User!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        repository = DatabasePasswordTokenRepository(database: app.db)
        try app.autoMigrate().wait()
        user = User(fullName: "Test User", email: "test@test.com", passwordHash: "123")
        try user.create(on: app.db).wait()
    }
    
    override func tearDownWithError() throws {
        try app.migrator.revertAllBatches().wait()
        app.shutdown()
    }
    
    func testFindByUserID() async throws {
        let userID = try user.requireID()
        let token = PasswordToken(userID: userID, token: "123")
        try await token.create(on: app.db)
        let user = try await repository.find(userID: userID)
        XCTAssertNotNil(user)
    }
    
    func testFindByToken() async throws {
        let token = PasswordToken(userID: try user.requireID(), token: "token123")
        try await token.create(on: app.db)
        let user = try await repository.find(token: "token123")
        XCTAssertNotNil(user)
    }
    
    func testCount() async throws {
        let token = PasswordToken(userID: try user.requireID(), token: "token123")
        let token2 = PasswordToken(userID: try user.requireID(), token: "token123")
        
        try await token.create(on: app.db)
        try await token2.create(on: app.db)
        let count = try await repository.count()
        XCTAssertEqual(count, 2)
    }
    
    func testCreate() async throws {
        let token = PasswordToken(userID: try user.requireID(), token: "token123")
        try await repository.create(token)
        let t = try await PasswordToken.find(try token.requireID(),
                                   on: app.db)
        
        XCTAssertNotNil(t)
    }
    
    func testDelete() async throws {
        let token = PasswordToken(userID: try user.requireID(), token: "token123")
        try await token.create(on: app.db)
        try await repository.delete(token)
        let count = try await PasswordToken.query(on: app.db).count()
        XCTAssertEqual(count, 0)
    }
    
}
    

