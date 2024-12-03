//
//  MedicineProtocols.swift
//  MediStock
//

import Foundation

protocol FirebaseServiceProtocol {
    func fetchListMedicines(completion: @escaping (Result<[Medicine], Error>) -> Void)
    func fetchAllMedicine(filter: String?, sortOption: SortOption, completion: @escaping (Result<[Medicine], Error>) -> Void)
    func addMedicine(name: String, stock: Int, aisle: String, completion: @escaping (Result<String, Error>) -> Void)
    func updateStock(medicineId: String, newStock: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func updateMedicine(medicine: Medicine, completion: @escaping (Result<Void, Error>) -> Void)
    func addHistory(history: HistoryEntry, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchHistory(for medicineId: String, completion: @escaping (Result<[HistoryEntry], Error>) -> Void)
    func deleteMedicines(by ids: [String], completion: @escaping (Result<Void, Error>) -> Void)
}

protocol MedicineStockManagerProtocol {
    func fetchMedicines(completion: @escaping (Result<[Medicine], Error>) -> Void)
    func fetchDynamicMedicines(filter: String?, sortOption: SortOption, completion: @escaping (Result<[Medicine], Error>) -> Void)
    func addMedicine(name: String, stock: Int, aisle: String, completion: @escaping (Result<String, Error>) -> Void)
    func deleteMedicines(by ids: [String], completion: @escaping (Result<Void, Error>) -> Void)
    func updateStock(medicine: Medicine, by amount: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func updateMedicine(medicine: Medicine, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchHistory(for medicineId: String, completion: @escaping (Result<[HistoryEntry], Error>) -> Void)
    func addHistory(history: HistoryEntry, completion: @escaping (Result<Void, Error>) -> Void)
}
