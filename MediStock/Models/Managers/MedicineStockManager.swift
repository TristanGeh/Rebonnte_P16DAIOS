//
//  MedicineStockManager.swift
//  MediStock
//

import Foundation

class MedicineStockManager: ObservableObject {
    private let service = FirebaseService()
    
    
    func fetchMedicines(completion: @escaping (Result<[Medicine], Error>) -> Void) {
        service.fetchListMedicines { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func fetchDynamicMedicines(filter: String? = nil, sortOption: SortOption = .none, completion: @escaping (Result<[Medicine], Error>) -> Void) {
        service.fetchAllMedicine(filter: filter, sortOption: sortOption) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func addMedicine(name: String, stock: Int, aisle: String, completion: @escaping (Result<String, Error>) -> Void) {
        service.addMedicine(name: name, stock: stock, aisle: aisle) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userEmail):
                    completion(.success(userEmail))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func addHistory(history: HistoryEntry, completion: @escaping (Result<Void, Error>) -> Void) {
        service.addHistory(history: history, completion: completion)
    }
    
    func fetchHistory(for medicineId: String, completion: @escaping (Result<[HistoryEntry], Error>) -> Void) {
        service.fetchHistory(for: medicineId, completion: completion)
    }
    
    func updateStock(medicine: Medicine, by amount: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let id = medicine.id else {
            completion(.failure(NSError(domain: "MedicineError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Medicine ID"])))
            return
        }
        let newStock = medicine.stock + amount
        service.updateStock(medicineId: id, newStock: newStock, completion: completion)
    }
    
    func updateMedicine(medicine: Medicine, completion: @escaping (Result<Void, Error>) -> Void) {
        service.updateMedicine(medicine: medicine, completion: completion)
    }
    
}
