//
//  MockFirebaseService.swift
//  MediStockTests
//

import Foundation
@testable import MediStock

class MockFirebaseService: FirebaseServiceProtocol {
    var medicines: [Medicine] = []
    var history: [HistoryEntry] = []
    var shouldSucceed = true

    func fetchListMedicines(completion: @escaping (Result<[Medicine], Error>) -> Void) {
        if shouldSucceed {
            completion(.success(medicines))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch medicines"])))
        }
    }

    func fetchAllMedicine(filter: String?, sortOption: SortOption, completion: @escaping (Result<[Medicine], Error>) -> Void) {
        if shouldSucceed {
            let filtered = medicines.filter {
                guard let filter = filter else { return true }
                return $0.name.contains(filter)
            }
            let sorted = filtered.sorted {
                switch sortOption {
                case .name: return $0.name < $1.name
                case .stock: return $0.stock < $1.stock
                case .none: return true
                }
            }
            completion(.success(sorted))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch all medicines"])))
        }
    }

    func addMedicine(name: String, stock: Int, aisle: String, completion: @escaping (Result<String, Error>) -> Void) {
        if shouldSucceed {
            let medicine = Medicine(name: name, stock: stock, aisle: aisle)
            medicines.append(medicine)
            completion(.success("test@example.com"))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to add medicine"])))
        }
    }

    func updateStock(medicineId: String, newStock: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldSucceed {
            if let index = medicines.firstIndex(where: { $0.id == medicineId }) {
                medicines[index].stock = newStock
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "MockError", code: 4, userInfo: [NSLocalizedDescriptionKey: "Medicine not found"])))
            }
        } else {
            completion(.failure(NSError(domain: "MockError", code: 5, userInfo: [NSLocalizedDescriptionKey: "Failed to update stock"])))
        }
    }

    func updateMedicine(medicine: Medicine, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldSucceed {
            if let index = medicines.firstIndex(where: { $0.id == medicine.id }) {
                medicines[index] = medicine
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "MockError", code: 6, userInfo: [NSLocalizedDescriptionKey: "Medicine not found"])))
            }
        } else {
            completion(.failure(NSError(domain: "MockError", code: 7, userInfo: [NSLocalizedDescriptionKey: "Failed to update medicine"])))
        }
    }

    func addHistory(history: HistoryEntry, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldSucceed {
            self.history.append(history)
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 8, userInfo: [NSLocalizedDescriptionKey: "Failed to add history"])))
        }
    }

    func fetchHistory(for medicineId: String, completion: @escaping (Result<[HistoryEntry], Error>) -> Void) {
        if shouldSucceed {
            let filteredHistory = history.filter { $0.medicineId == medicineId }
            completion(.success(filteredHistory))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 9, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch history"])))
        }
    }

    func deleteMedicines(by ids: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldSucceed {
            medicines.removeAll { ids.contains($0.id ?? "") }
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "MockError", code: 10, userInfo: [NSLocalizedDescriptionKey: "Failed to delete medicines"])))
        }
    }
}
