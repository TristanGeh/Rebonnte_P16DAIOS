//
//  SessionViewModel.swift
//  MediStock
//

import Foundation

class SessionViewModel: ObservableObject {
    @Published var session: User?
    @Published var errorMessage: String?
    
    private let sessionStore: SessionStoreProtocol
    private let manager: SessionManagerProtocol
    
    init(sessionStore: SessionStoreProtocol = SessionStore(),
         manager: SessionManagerProtocol? = nil) {
        self.sessionStore = sessionStore
        self.manager = manager ?? SessionManager(sessionStore: sessionStore)
    }
    
    func listen() {
        manager.listen { [weak self] user in
            DispatchQueue.main.async {
                self?.session = user
            }
        }
    }
    
    func signUp(email: String, password: String) {
        manager.signUp(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.session = user
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func signIn(email: String, password: String) {
        manager.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.session = user
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func signOut() {
        manager.signOut { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.session = nil
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
