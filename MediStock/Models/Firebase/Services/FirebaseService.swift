//
//  FirebaseService.swift
//  MediStock
//

import Foundation
import Firebase
import FirebaseAuth

enum SortOption: String, CaseIterable, Identifiable {
    case none
    case name
    case stock

    var id: String { self.rawValue }
}

class FirebaseService: FirebaseServiceProtocol {
    private var db = Firestore.firestore()
    
    func fetchListMedicines(completion: @escaping (Result<[Medicine], Error>) -> Void) {
        db.collection("medicines").getDocuments { (querySnapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            } else {
                let medicines = querySnapshot?.documents.compactMap{ try? $0.data(as: Medicine.self)} ?? []
                DispatchQueue.main.async {
                    completion(.success(medicines))
                }
            }
        }
    }
    
    func fetchAllMedicine(filter: String? = nil, sortOption: SortOption = .none, completion: @escaping (Result<[Medicine], Error>) -> Void) {
        
        var query: Query = db.collection("medicines")
        
        if let filter = filter, !filter.isEmpty {
            query = query.whereField("name", isGreaterThanOrEqualTo: filter)
                         .whereField("name", isLessThanOrEqualTo: filter + "\u{f8ff}")
        }
        
        switch sortOption {
        case .name:
            query = query.order(by: "name")
        case .stock:
            query = query.order(by: "stock")
        case .none:
            break
        }
        
        query.addSnapshotListener { snapshot, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            } else {
                let medicines = snapshot?.documents.compactMap { try? $0.data(as: Medicine.self)} ?? []
                DispatchQueue.main.async {
                    completion(.success(medicines))
                }
            }
        }
    }
    
    func addMedicine(name: String, stock: Int, aisle: String, completion: @escaping (Result<String, Error>) -> Void) {
        let medicine = Medicine(name: name, stock: stock, aisle: aisle)
        
        guard let userEmail = Auth.auth().currentUser?.email else {
                completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
                return
            }
        let medicineID = medicine.id ?? UUID().uuidString
        do {
            try db.collection("medicines").document(medicineID).setData(from: medicine)
            completion(.success(userEmail))
        } catch let error {
            completion(.failure(error))
            print("Error adding document: \(error)")
        }
    }
    
    func updateStock(medicineId: String, newStock: Int, completion: @escaping (Result<Void, Error>) -> Void) {
            db.collection("medicines").document(medicineId).updateData([
                "stock": newStock
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }

        func updateMedicine(medicine: Medicine, completion: @escaping (Result<Void, Error>) -> Void) {
            guard let medicineId = medicine.id else {
                completion(.failure(NSError(domain: "MedicineError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Medicine ID"])))
                return
            }
            
            do {
                try db.collection("medicines").document(medicineId).setData(from: medicine)
                completion(.success(()))
            } catch let error {
                completion(.failure(error))
            }
        }

        func addHistory(history: HistoryEntry, completion: @escaping (Result<Void, Error>) -> Void) {
            let historyID = history.id ?? UUID().uuidString
            do {
                try db.collection("history").document(historyID).setData(from: history)
                completion(.success(()))
            } catch let error {
                completion(.failure(error))
            }
        }

        func fetchHistory(for medicineId: String, completion: @escaping (Result<[HistoryEntry], Error>) -> Void) {
            db.collection("history").whereField("medicineId", isEqualTo: medicineId).addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let history = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: HistoryEntry.self)
                    } ?? []
                    completion(.success(history))
                }
            }
        }
    
    func deleteMedicines(by ids: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        let batch = db.batch()
        
        ids.forEach { id in
            let documentRef = db.collection("medicines").document(id)
            batch.deleteDocument(documentRef)
        }
        
        batch.commit { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
