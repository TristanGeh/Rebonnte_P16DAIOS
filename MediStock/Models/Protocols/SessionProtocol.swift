//
//  SessionProtocol.swift
//  MediStock
//

import Foundation

protocol SessionStoreProtocol {
    var session: User? { get set }
    func listen(completion: @escaping (User?) -> Void)
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func signOut(completion: @escaping (Result<Void, Error>) -> Void)
    func unbind()
}

protocol SessionManagerProtocol {
    func listen(completion: @escaping (User?) -> Void)
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func signOut(completion: @escaping (Result<Void, Error>) -> Void)
}

