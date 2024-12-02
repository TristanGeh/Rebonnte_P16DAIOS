import Foundation
import Firebase

class SessionStore: ObservableObject {
    @Published var session: User?
    private var handle: AuthStateDidChangeListenerHandle?

    func listen(completion: @escaping (User?) -> Void) {
        handle = Auth.auth().addStateDidChangeListener { (_, user) in
            if let user = user {
                let session = User(uid: user.uid, email: user.email)
                self.session = session
                completion(session)
            } else {
                self.session = nil
                completion(nil)
            }
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else if let result = result {
                let user = User(uid: result.user.uid, email: result.user.email)
                self.session = user
                completion(.success(user))
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else if let result = result {
                let user = User(uid: result.user.uid, email: result.user.email)
                self.session = user
                completion(.success(user))
            }
        }
    }

    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            self.session = nil
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }

    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}


struct User {
    var uid: String
    var email: String?
}
