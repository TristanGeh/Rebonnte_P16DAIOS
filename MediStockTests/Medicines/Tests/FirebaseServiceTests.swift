//
//  FirebaseServiceTests.swift
//  MediStockTests
//

import XCTest
@testable import MediStock

final class FirebaseServiceTests: XCTestCase {
    var mockService: MockFirebaseService!

    override func setUp() {
        super.setUp()
        mockService = MockFirebaseService()
    }

    override func tearDown() {
        mockService = nil
        super.tearDown()
    }

    func testFetchListMedicinesSuccess() {
        // Given
        mockService.medicines = [Medicine(name: "Aspirin", stock: 100, aisle: "A1")]
        mockService.shouldSucceed = true
        
        let expectation = self.expectation(description: "Fetch medicines success")

        // When
        mockService.fetchListMedicines { result in
            // Then
            switch result {
            case .success(let medicines):
                XCTAssertEqual(medicines.count, 1)
                XCTAssertEqual(medicines.first?.name, "Aspirin")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testAddMedicineFailure() {
        // Given
        mockService.shouldSucceed = false
        
        let expectation = self.expectation(description: "Add medicine failure")

        // When
        mockService.addMedicine(name: "Paracetamol", stock: 50, aisle: "A2") { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to add medicine")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}

