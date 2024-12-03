//
//  SessionManager.swift
//  MediStock
//

import Foundation

class SessionManager: SessionManagerProtocol {
    private let sessionStore: SessionStoreProtocol
    
    init(sessionStore: SessionStoreProtocol) {
        self.sessionStore = sessionStore
    }

    func listen(completion: @escaping (User?) -> Void) {
        sessionStore.listen { user in
            completion(user)
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        sessionStore.signUp(email: email, password: password) { result in
            completion(result)
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        sessionStore.signIn(email: email, password: password) { result in
            completion(result)
        }
    }

    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        sessionStore.signOut { result in
            completion(result)
        }
    }

    func unbind() {
        sessionStore.unbind()
    }
}
