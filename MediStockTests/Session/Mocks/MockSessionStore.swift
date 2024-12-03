//
//  MockSessionStore.swift
//  MediStockTests
//

import Foundation
@testable import MediStock

class MockSessionStore: SessionStoreProtocol {
    var session: User?

    func listen(completion: @escaping (User?) -> Void) {
        completion(session)
    }

    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        if email == "test@example.com" && password == "password" {
            let user = User(uid: "123", email: email)
            session = user
            completion(.success(user))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])))
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        if email == "test@example.com" && password == "password" {
            let user = User(uid: "123", email: email)
            session = user
            completion(.success(user))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])))
        }
    }

    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        session = nil
        completion(.success(()))
    }

    func unbind() {}
}
