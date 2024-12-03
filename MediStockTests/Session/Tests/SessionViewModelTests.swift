//
//  SessionViewModelTests.swift
//  MediStockTests
//

import XCTest
@testable import MediStock

final class SessionViewModelTests: XCTestCase {
    
    var mockSessionManager: MockSessionManager!
    var viewModel: SessionViewModel!
    
    override func setUp() {
        super.setUp()
        mockSessionManager = MockSessionManager()
        viewModel = SessionViewModel(sessionStore: MockSessionStore(), manager: mockSessionManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockSessionManager = nil
        super.tearDown()
    }
    
    func testSignUpSuccess() {
        // Given
        mockSessionManager.shouldSucceed = true
        let expectation = self.expectation(description: "SignUp Success")
        
        // When
        viewModel.signUp(email: "test@example.com", password: "password")
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.viewModel.session)
            XCTAssertEqual(self.viewModel.session?.email, "test@example.com")
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testSignUpFailure() {
        // Given
        mockSessionManager.shouldSucceed = false
        let expectation = self.expectation(description: "SignUp Failure")
        
        // When
        viewModel.signUp(email: "wrong@example.com", password: "wrong")
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNil(self.viewModel.session)
            XCTAssertEqual(self.viewModel.errorMessage, "Mock sign-up error")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testSignInSuccess() {
        // Given
        mockSessionManager.shouldSucceed = true
        let expectation = self.expectation(description: "SignIn Success")
        
        // When
        viewModel.signIn(email: "test@example.com", password: "password")
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNotNil(self.viewModel.session)
            XCTAssertEqual(self.viewModel.session?.email, "test@example.com")
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testSignInFailure() {
        // Given
        mockSessionManager.shouldSucceed = false
        let expectation = self.expectation(description: "SignIn Failure")
        
        // When
        viewModel.signIn(email: "wrong@example.com", password: "wrong")
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNil(self.viewModel.session)
            XCTAssertEqual(self.viewModel.errorMessage, "Mock sign-in error")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testSignOutSuccess() {
        // Given
        mockSessionManager.shouldSucceed = true
        viewModel.session = User(uid: "123", email: "test@example.com")
        let expectation = self.expectation(description: "SignOut Success")
        
        // When
        viewModel.signOut()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNil(self.viewModel.session)
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
}

