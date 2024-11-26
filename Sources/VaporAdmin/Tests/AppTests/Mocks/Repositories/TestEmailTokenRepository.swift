@testable import App
import Vapor

class TestEmailTokenRepository: EmailTokenRepository, TestRepository {
    var tokens: [EmailToken]
    var eventLoop: EventLoop
    
    init(tokens: [EmailToken] = [], eventLoop: EventLoop) {
        self.tokens = tokens
        self.eventLoop = eventLoop
    }
    
    func find(token: String) async throws -> EmailToken? {
        tokens.first(where: { $0.token == token })
    }
    
    func create(_ emailToken: EmailToken)  {
        tokens.append(emailToken)
        
    }
    
    func delete(_ emailToken: EmailToken) async throws {
        tokens.removeAll(where: { $0.id == emailToken.id })
    }
    
    
    func find(userID: UUID) async throws -> EmailToken? {
        tokens.first(where: { $0.$user.id == userID })
    }
}
