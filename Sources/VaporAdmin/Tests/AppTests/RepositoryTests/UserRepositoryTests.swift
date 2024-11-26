@testable import App
import Fluent
import XCTVapor

final class UserRepositoryTests: XCTestCase {
    var app: Application!
    var repository: UserRepository!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        repository = DatabaseUserRepository(database: app.db)
        try app.autoMigrate().wait()
    }
    
    override func tearDownWithError() throws {
        try app.autoRevert().wait()
        app.shutdown()
    }
    
    func testCreatingUser() async throws {
        let user = User(fullName: "Test User", email: "test@test.com", passwordHash: "123")
        try await repository.create(user)
        
        XCTAssertNotNil(user.id)
        
        let userRetrieved = try await User.find(user.id, on: app.db)
        XCTAssertNotNil(userRetrieved)
    }
    
    func testDeletingUser() async throws {
        let user = User(fullName: "Test User", email: "test@test.com", passwordHash: "123")
        try await user.create(on: app.db)
        let count = try await User.query(on: app.db).count()
        XCTAssertEqual(count, 1)
        
        try await repository.delete(id: user.requireID())
        let countAfterDelete = try await User.query(on: app.db).count()
        XCTAssertEqual(countAfterDelete, 0)
    }
    
    func testGetAllUsers() async throws {
        let user = User(fullName: "Test User", email: "test@test.com", passwordHash: "123")
        let user2 = User(fullName: "Test User 2", email: "test2@test.com", passwordHash: "123")
        
        try await user.create(on: app.db)
        try await user2.create(on: app.db)
        
        let users = try await repository.all()
        XCTAssertEqual(users.count, 2)
    }
    
    func testFindUserById() async throws {
        let user = User(fullName: "Test User", email: "test@test.com", passwordHash: "123")
        try await user.create(on: app.db)
        
        let userFound = try await repository.find(id: user.requireID())
        XCTAssertNotNil(userFound)
    }
    
    func testSetFieldValue() async throws {
        let user = User(fullName: "Test User", email: "test@test.com", passwordHash: "123", isEmailVerified: false)
        try await user.create(on: app.db)
        
        try await repository.set(\.$isEmailVerified, to: true, for: user.requireID())
    
        let updatedUser = try await User.find(user.id!, on: app.db)
        XCTAssertEqual(updatedUser!.isEmailVerified, true)
    }
}
    

