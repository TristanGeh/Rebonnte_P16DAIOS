//
//  MedicineManagerTests.swift
//  MediStockTests
//

import XCTest
@testable import MediStock

final class MedicineStockManagerTests: XCTestCase {
    var mockService: MockFirebaseService!
    var manager: MedicineStockManager!
    
    override func setUp() {
        super.setUp()
        mockService = MockFirebaseService()
        manager = MedicineStockManager(service: mockService)
    }
    
    override func tearDown() {
        mockService = nil
        manager = nil
        super.tearDown()
    }
    
    // MARK: - Tests for fetchMedicines
    
    func testFetchMedicinesSuccess() {
        // Given
        mockService.medicines = [Medicine(name: "Aspirin", stock: 100, aisle: "A1")]
        mockService.shouldSucceed = true
        
        let expectation = self.expectation(description: "Fetch medicines success")
        
        // When
        manager.fetchMedicines { result in
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
    
    func testFetchMedicinesFailure() {
        // Given
        mockService.shouldSucceed = false
        
        let expectation = self.expectation(description: "Fetch medicines failure")
        
        // When
        manager.fetchMedicines { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to fetch medicines")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    // MARK: - Tests for fetchDynamicMedicines
    
    func testFetchDynamicMedicinesSuccess() {
        // Given
        mockService.shouldSucceed = true
        mockService.medicines = [Medicine(name: "Aspirin", stock: 50, aisle: "A1")]
        let expectation = self.expectation(description: "Fetch dynamic medicines success")
        
        // When
        manager.fetchDynamicMedicines(filter: "Asp", sortOption: .name) { result in
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
    
    func testFetchDynamicMedicinesFailure() {
        // Given
        mockService.shouldSucceed = false
        let expectation = self.expectation(description: "Fetch dynamic medicines failure")
        
        // When
        manager.fetchDynamicMedicines(filter: "Nonexistent", sortOption: .name) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to fetch all medicines")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }


    
    // MARK: - Tests for addMedicine
    
    func testAddMedicineSuccess() {
        // Given
        mockService.shouldSucceed = true
        
        let expectation = self.expectation(description: "Add medicine success")
        
        // When
        manager.addMedicine(name: "Paracetamol", stock: 50, aisle: "A2") { result in
            // Then
            switch result {
            case .success(let userEmail):
                XCTAssertEqual(userEmail, "test@example.com")
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
        manager.addMedicine(name: "Paracetamol", stock: 50, aisle: "A2") { result in
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
    
    // MARK: - Tests for deleteMedicines
    
    func testDeleteMedicinesSuccess() {
        // Given
        mockService.shouldSucceed = true
        
        let expectation = self.expectation(description: "Delete medicines success")
        
        // When
        manager.deleteMedicines(by: ["AspirinID"]) { result in
            // Then
            switch result {
            case .success:
                XCTAssertTrue(true) // Successful deletion
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testDeleteMedicinesFailure() {
        // Given
        mockService.shouldSucceed = false
        
        let expectation = self.expectation(description: "Delete medicines failure")
        
        // When
        manager.deleteMedicines(by: ["AspirinID"]) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to delete medicines")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    // MARK: - Tests for updateStock
    
    func testUpdateStockSuccess() {
        // Given
        mockService.shouldSucceed = true
        
        let medicine = Medicine(id: "AspirinID", name: "Aspirin", stock: 50, aisle: "A1")
        mockService.medicines = [medicine]
        let expectation = self.expectation(description: "Update stock success")
        
        // When
        manager.updateStock(medicine: medicine, by: 10) { result in
            // Then
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testUpdateStockFailure() {
        // Given
        mockService.shouldSucceed = false
        
        let medicine = Medicine(id: "AspirinID", name: "Aspirin", stock: 50, aisle: "A1")
        mockService.medicines = [medicine]
        let expectation = self.expectation(description: "Update stock failure")
        
        // When
        manager.updateStock(medicine: medicine, by: 10) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to update stock")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    // MARK: - Tests for fetchHistory
    
    func testFetchHistorySuccess() {
        // Given
        mockService.history = [HistoryEntry(medicineId: "AspirinID", user: "mock@example.com", action: "Added", details: "Added Aspirin")]
        mockService.shouldSucceed = true
        
        let expectation = self.expectation(description: "Fetch history success")
        
        // When
        manager.fetchHistory(for: "AspirinID") { result in
            // Then
            switch result {
            case .success(let history):
                XCTAssertEqual(history.count, 1)
                XCTAssertEqual(history.first?.action, "Added")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFetchHistoryFailure() {
        // Given
        mockService.shouldSucceed = false
        
        let expectation = self.expectation(description: "Fetch history failure")
        
        // When
        manager.fetchHistory(for: "AspirinID") { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to fetch history")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testAddHistorySuccess() {
        // Given
        mockService.shouldSucceed = true
        let history = HistoryEntry(medicineId: "1", user: "test@example.com", action: "Added", details: "Added medicine")
        let expectation = self.expectation(description: "Add history success")
        
        // When
        manager.addHistory(history: history) { result in
            // Then
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testAddHistoryFailure() {
        // Given
        mockService.shouldSucceed = false
        let history = HistoryEntry(medicineId: "1", user: "test@example.com", action: "Added", details: "Added medicine")
        let expectation = self.expectation(description: "Add history failure")
        
        // When
        manager.addHistory(history: history) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to add history")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    
    func testUpdateMedicineSuccess() {
        // Given
        mockService.shouldSucceed = true
        let oldMedicine = Medicine(id: "1", name: "Aspirine", stock: 51, aisle: "A1")
        let medicine = Medicine(id: "1", name: "Aspirin", stock: 50, aisle: "A1")
        mockService.medicines = [oldMedicine]
        let expectation = self.expectation(description: "Update medicine success")
        
        // When
        manager.updateMedicine(medicine: medicine) { result in
            // Then
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }

    func testUpdateMedicineFailure() {
        // Given
        mockService.shouldSucceed = false
        let oldMedicine = Medicine(id: "1", name: "Aspirine", stock: 51, aisle: "A1")
        let medicine = Medicine(id: "1", name: "Aspirin", stock: 50, aisle: "A1")
        mockService.medicines = [oldMedicine]
        let expectation = self.expectation(description: "Update medicine failure")
        
        // When
        manager.updateMedicine(medicine: medicine) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to update medicine")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }

}
