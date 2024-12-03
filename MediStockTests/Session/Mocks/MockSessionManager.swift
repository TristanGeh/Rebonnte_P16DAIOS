//
//  MockSessionManager.swift
//  MediStockTests
//

import Foundation
@testable import MediStock

class MockSessionManager: SessionManagerProtocol {
    var session: User?
    var shouldSucceed: Bool = true

    func listen(completion: @escaping (User?) -> Void) {
        completion(session)
    }

    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        if shouldSucceed {
            let user = User(uid: "123", email: email)
            session = user
            completion(.success(user))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Mock sign-up error"])))
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        if shouldSucceed {
            let user = User(uid: "123", email: email)
            session = user
            completion(.success(user))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Mock sign-in error"])))
        }
    }

    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldSucceed {
            session = nil
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Mock sign-out error"])))
        }
    }
}
