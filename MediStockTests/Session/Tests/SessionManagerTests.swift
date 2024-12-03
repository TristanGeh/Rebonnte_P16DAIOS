//
//  SessionManagerTests.swift
//  MediStockTests
//

import XCTest
@testable import MediStock

final class SessionManagerTests: XCTestCase {
    
    var mockSessionStore: MockSessionStore!
    var sessionManager: SessionManager!
    
    override func setUp() {
        super.setUp()
        mockSessionStore = MockSessionStore()
        sessionManager = SessionManager(sessionStore: mockSessionStore)
    }
    
    override func tearDown() {
        mockSessionStore = nil
        sessionManager = nil
        super.tearDown()
    }
    
    func testSignUpSuccess() {
        let expectation = self.expectation(description: "SignUp Success")
        
        sessionManager.signUp(email: "test@example.com", password: "password") { result in
            switch result {
            case .success(let user):
                XCTAssertEqual(user.email, "test@example.com")
                XCTAssertNotNil(user.uid)
            case .failure:
                XCTFail("SignUp should succeed")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testSignUpFailure() {
        let expectation = self.expectation(description: "SignUp Failure")
        
        sessionManager.signUp(email: "wrong@example.com", password: "wrong") { result in
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
        let expectation = self.expectation(description: "SignIn Success")
        
        sessionManager.signIn(email: "test@example.com", password: "password") { result in
            switch result {
            case .success(let user):
                XCTAssertEqual(user.email, "test@example.com")
                XCTAssertNotNil(user.uid)
            case .failure:
                XCTFail("SignIn should succeed")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testSignInFailure() {
        let expectation = self.expectation(description: "SignIn Failure")
        
        sessionManager.signIn(email: "wrong@example.com", password: "wrong") { result in
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
        let expectation = self.expectation(description: "SignOut")
        
        sessionManager.signOut { result in
            switch result {
            case .success:
                XCTAssertNil(self.mockSessionStore.session)
            case .failure:
                XCTFail("SignOut should succeed")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
}
