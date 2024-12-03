//
//  SessionStoreTests.swift
//  MediStockTests
//

import XCTest
@testable import MediStock

final class SessionStoreTests: XCTestCase {
    var mockSessionStore: MockSessionStore!
    var sessionStore: SessionStoreProtocol!

    override func setUp() {
        super.setUp()
        mockSessionStore = MockSessionStore()
        sessionStore = mockSessionStore 
    }

    override func tearDown() {
        mockSessionStore = nil
        sessionStore = nil
        super.tearDown()
    }

    func testSignUpSuccess() {
        // Given
        let expectation = self.expectation(description: "SignUp Success")
        
        // When
        sessionStore.signUp(email: "test@example.com", password: "password") { result in
            // Then
            switch result {
            case .success(let user):
                XCTAssertEqual(user.email, "test@example.com")
                XCTAssertEqual(user.uid, "123")
            case .failure:
                XCTFail("SignUp should succeed")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testSignUpFailure() {
        // Given
        let expectation = self.expectation(description: "SignUp Failure")
        
        // When
        sessionStore.signUp(email: "wrong@example.com", password: "wrong") { result in
            // Then
            switch result {
            case .success:
                XCTFail("SignUp should fail")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Invalid credentials")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testSignInSuccess() {
        // Given
        let expectation = self.expectation(description: "SignIn Success")
        
        // When
        sessionStore.signIn(email: "test@example.com", password: "password") { result in
            // Then
            switch result {
            case .success(let user):
                XCTAssertEqual(user.email, "test@example.com")
                XCTAssertEqual(user.uid, "123")
            case .failure:
                XCTFail("SignIn should succeed")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testSignInFailure() {
        // Given
        let expectation = self.expectation(description: "SignIn Failure")
        
        // When
        sessionStore.signIn(email: "wrong@example.com", password: "wrong") { result in
            // Then
            switch result {
            case .success:
                XCTFail("SignIn should fail")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Invalid credentials")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testSignOut() {
        // Given
        let expectation = self.expectation(description: "SignOut")
        
        // When
        sessionStore.signOut { result in
            // Then
            switch result {
            case .success:
                XCTAssertNil(self.mockSessionStore.session, "Session should be nil after sign out")
            case .failure:
                XCTFail("SignOut should succeed")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testListen() {
        // Given
        let expectation = self.expectation(description: "Listen")
        mockSessionStore.session = User(uid: "123", email: "test@example.com")
        
        // When
        sessionStore.listen { user in
            // Then
            XCTAssertEqual(user?.email, "test@example.com")
            XCTAssertEqual(user?.uid, "123")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}


