//
//  MedicineStockManagerMock.swift
//  MediStockTests
//

import Foundation
@testable import MediStock

class MockMedicineStockManager: MedicineStockManagerProtocol {
    var medicines: [Medicine] = []
    var history: [HistoryEntry] = []
    var shouldSucceed = true

    func fetchMedicines(completion: @escaping (Result<[Medicine], Error>) -> Void) {
        if shouldSucceed {
            completion(.success(medicines))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Fetch failed"])))
        }
    }

    func fetchDynamicMedicines(filter: String?, sortOption: SortOption, completion: @escaping (Result<[Medicine], Error>) -> Void) {
        if shouldSucceed {
            let filtered = medicines.filter { filter == nil || $0.name.contains(filter!) }
            completion(.success(filtered))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Fetch failed"])))
        }
    }

    func addMedicine(name: String, stock: Int, aisle: String, completion: @escaping (Result<String, Error>) -> Void) {
        if shouldSucceed {
            let medicine = Medicine(name: name, stock: stock, aisle: aisle)
            medicines.append(medicine)
            completion(.success("mock@example.com"))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Add failed"])))
        }
    }

    func deleteMedicines(by ids: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldSucceed {
            medicines.removeAll { ids.contains($0.id ?? "") }
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 4, userInfo: [NSLocalizedDescriptionKey: "Delete failed"])))
        }
    }

    func updateStock(medicine: Medicine, by amount: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldSucceed {
            if let index = medicines.firstIndex(where: { $0.id == medicine.id }) {
                medicines[index].stock += amount
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "MockError", code: 5, userInfo: [NSLocalizedDescriptionKey: "Update failed"])))
            }
        } else {
            completion(.failure(NSError(domain: "MockError", code: 6, userInfo: [NSLocalizedDescriptionKey: "Update failed"])))
        }
    }

    func updateMedicine(medicine: Medicine, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldSucceed {
            if let index = medicines.firstIndex(where: { $0.id == medicine.id }) {
                medicines[index] = medicine
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "MockError", code: 7, userInfo: [NSLocalizedDescriptionKey: "Not found"])))
            }
        } else {
            completion(.failure(NSError(domain: "MockError", code: 8, userInfo: [NSLocalizedDescriptionKey: "Update failed"])))
        }
    }

    func fetchHistory(for medicineId: String, completion: @escaping (Result<[HistoryEntry], Error>) -> Void) {
        if shouldSucceed {
            let filtered = history.filter { $0.medicineId == medicineId }
            completion(.success(filtered))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 9, userInfo: [NSLocalizedDescriptionKey: "Fetch failed"])))
        }
    }

    func addHistory(history: HistoryEntry, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldSucceed {
            self.history.append(history)
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 10, userInfo: [NSLocalizedDescriptionKey: "Add failed"])))
        }
    }
}
