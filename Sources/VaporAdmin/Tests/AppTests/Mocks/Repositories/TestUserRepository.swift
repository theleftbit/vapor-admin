@testable import App
import Vapor
import Fluent

class TestUserRepository: UserRepository, TestRepository {
    
    
    var users: [User]
    var eventLoop: EventLoop
    
    init(users: [User] = [User](), eventLoop: EventLoop) {
        self.users = users
        self.eventLoop = eventLoop
    }
    
    func create(_ user: User) async throws {
        user.id = UUID()
        users.append(user)
    }
    
    func delete(id: UUID) {
        users.removeAll(where: { $0.id == id })
    }
    
    func all() -> [User] {
        users
    }
    
    func find(id: UUID?) -> User? {
        users.first(where: { $0.id == id })
        
    }
    
    func find(email: String) -> User? {
        users.first(where: { $0.email == email })
    }
    
    func set<Field>(_ field: KeyPath<User, Field>, to value: Field.Value, for userID: UUID)async throws where Field : QueryableProperty, Field.Model == User {
        let user = users.first(where: { $0.id == userID })!
        user[keyPath: field].value = value
    }
    
    func count() async throws -> Int {
        users.count
    }
}
