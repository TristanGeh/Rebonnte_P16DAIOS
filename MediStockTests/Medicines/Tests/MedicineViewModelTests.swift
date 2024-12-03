//
//  MedicineViewModelTests.swift
//  MediStockTests
//

import XCTest
@testable import MediStock

final class MedicineStockViewModelTests: XCTestCase {
    var mockManager: MockMedicineStockManager!
    var viewModel: MedicineStockViewModel!
    
    override func setUp() {
        super.setUp()
        mockManager = MockMedicineStockManager()
        viewModel = MedicineStockViewModel(manager: mockManager)
    }
    
    override func tearDown() {
        mockManager = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchMedicinesSuccess() {
        // Given
        mockManager.medicines = [Medicine(name: "Aspirin", stock: 50, aisle: "A1")]
        mockManager.shouldSucceed = true
        let expectation = self.expectation(description: "Fetch medicines success")
        
        // When
        viewModel.fetchMedicines()
        
        DispatchQueue.main.async {
            // Then
            XCTAssertEqual(self.viewModel.medicines.count, 1)
            XCTAssertEqual(self.viewModel.medicines.first?.name, "Aspirin")
            XCTAssertEqual(self.viewModel.aisles.first, "A1")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFetchMedicinesFailure() {
        // Given
        mockManager.shouldSucceed = false
        let expectation = self.expectation(description: "Fetch medicines failure")
        
        // When
        viewModel.fetchMedicines()
        
        DispatchQueue.main.async {
            // Then
            XCTAssertTrue(self.viewModel.medicines.isEmpty)
            XCTAssertEqual(self.viewModel.errorMessage, "Fetch failed")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    
    func testFetchDynamicMedicinesSuccess() {
        // Given
        mockManager.medicines = [
            Medicine(name: "Aspirin", stock: 50, aisle: "A1"),
            Medicine(name: "Paracetamol", stock: 30, aisle: "A1")
        ]
        mockManager.shouldSucceed = true
        let expectation = self.expectation(description: "Fetch dynamic medicines success")
        
        // When
        viewModel.fetchDynamicMedicines(filter: "Para", sortOption: .none)
        
        DispatchQueue.main.async {
            // Then
            XCTAssertEqual(self.viewModel.medicines.count, 1)
            XCTAssertEqual(self.viewModel.medicines.first?.name, "Paracetamol")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFetchDynamicMedicinesFailure() {
        // Given
        mockManager.shouldSucceed = false
        let expectation = self.expectation(description: "Fetch dynamic medicines failure")
        
        // When
        viewModel.fetchDynamicMedicines(filter: "Aspirin", sortOption: .none)
        
        DispatchQueue.main.async {
            // Then
            XCTAssertTrue(self.viewModel.medicines.isEmpty)
            XCTAssertEqual(self.viewModel.errorMessage, "Fetch failed")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testAddMedicineSuccess() {
        // Given
        mockManager.shouldSucceed = true
        let expectation = self.expectation(description: "Add medicine success")
        
        // When
        viewModel.addMedicine(name: "Ibuprofen", stock: 20, aisle: "A2")
        
        DispatchQueue.main.async {
            // Then
            XCTAssertEqual(self.viewModel.medicines.count, 1)
            XCTAssertEqual(self.viewModel.medicines.first?.name, "Ibuprofen")
            XCTAssertEqual(self.viewModel.aisles.first, "A2")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testAddMedicineFailure() {
        // Given
        mockManager.shouldSucceed = false
        let expectation = self.expectation(description: "Add medicine failure")
        
        // When
        viewModel.addMedicine(name: "Ibuprofen", stock: 20, aisle: "A2")
        
        DispatchQueue.main.async {
            // Then
            XCTAssertTrue(self.viewModel.medicines.isEmpty)
            XCTAssertEqual(self.viewModel.errorMessage, "Failed to add medicine: Add failed")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testDeleteMedicinesSuccess() {
        // Given
        let aspirin = Medicine(id: "AspirinID", name: "Aspirin", stock: 50, aisle: "A1")
        mockManager.medicines = [aspirin]
        viewModel.medicines = mockManager.medicines
        mockManager.shouldSucceed = true
        let expectation = self.expectation(description: "Delete medicines success")
        
        // When
        viewModel.deleteMedicines(["AspirinID"], for: "A1")
        
        DispatchQueue.main.async {
            // Then
            XCTAssertTrue(self.viewModel.medicines.isEmpty)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testDeleteMedicinesFailure() {
        // Given
        mockManager.medicines = [Medicine(name: "Aspirin", stock: 50, aisle: "A1")]
        viewModel.medicines = mockManager.medicines
        mockManager.shouldSucceed = false
        let expectation = self.expectation(description: "Delete medicines failure")
        
        // When
        viewModel.deleteMedicines(["AspirinID"], for: "A1")
        
        DispatchQueue.main.async {
            // Then
            XCTAssertFalse(self.viewModel.medicines.isEmpty)
            XCTAssertEqual(self.viewModel.errorMessage, "Failed to delete medicines: Delete failed")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFetchHistorySuccess() {
        // Given
        let medicine = Medicine(id: "AspirinID", name: "Aspirin", stock: 50, aisle: "A1")
        mockManager.history = [HistoryEntry(medicineId: "AspirinID", user: "test@example.com", action: "Added", details: "Details")]
        mockManager.shouldSucceed = true
        let expectation = self.expectation(description: "Fetch history success")
        
        // When
        viewModel.fetchHistory(for: medicine)
        
        DispatchQueue.main.async {
            // Then
            XCTAssertEqual(self.viewModel.history.count, 1)
            XCTAssertEqual(self.viewModel.history.first?.action, "Added")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFetchHistoryFailure() {
        // Given
        let medicine = Medicine(id: "AspirinID", name: "Aspirin", stock: 50, aisle: "A1")
        mockManager.shouldSucceed = false
        let expectation = self.expectation(description: "Fetch history failure")
        
        // When
        viewModel.fetchHistory(for: medicine)
        
        DispatchQueue.main.async {
            // Then
            XCTAssertTrue(self.viewModel.history.isEmpty)
            XCTAssertEqual(self.viewModel.errorMessage, "Fetch failed")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
}

