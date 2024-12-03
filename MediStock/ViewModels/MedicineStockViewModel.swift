import Foundation

class MedicineStockViewModel: ObservableObject {
    @Published var medicines: [Medicine] = []
    @Published var aisles: [String] = []
    @Published var history: [HistoryEntry] = []
    
    var errorMessage: String = ""
    
    private let manager: MedicineStockManagerProtocol
    
    init(manager: MedicineStockManagerProtocol = MedicineStockManager()) {
        self.manager = manager
    }
    
    func fetchMedicines() {
        manager.fetchMedicines { result in
            switch result {
            case .success(let medicines):
                DispatchQueue.main.async {
                    let processedAisles = Array(Set(medicines.map { $0.aisle })).sorted()
                    self.medicines = medicines
                    self.aisles = processedAisles
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    
    func fetchDynamicMedicines(filter: String? = nil, sortOption: SortOption = .none) {
        manager.fetchDynamicMedicines(filter: filter, sortOption: sortOption) { result in
            switch result {
            case .success(let medicines):
                self.medicines = medicines
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    
    func addMedicine(name: String, stock: Int, aisle: String) {
        manager.addMedicine(name: name, stock: stock, aisle: aisle) { result in
            switch result {
            case .success(let userEmail):
                let newMedicine = Medicine(name: name, stock: stock, aisle: aisle)
                
                self.addHistory(action: "Added \(name)",
                                user: userEmail,
                                medicineId: newMedicine.id ?? "",
                                details: "Added new medicine")
                
                self.fetchMedicines()
            case .failure(let error):
                self.errorMessage = ("Failed to add medicine: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteMedicines(_ ids: Set<String>, for aisle: String) {
        let medicinesToDelete = medicines.filter{ ids.contains($0.id ?? "")}
        
        manager.deleteMedicines(by: medicinesToDelete.compactMap{ $0.id}) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.medicines.removeAll { medicine in
                        ids.contains(medicine.id ?? "")
                    }
                case .failure(let error):
                    self.errorMessage = "Failed to delete medicines: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func increaseStock(_ medicine: Medicine, user: String) {
        updateStock(medicine, by: 1, user: user)
    }
    
    func decreaseStock(_ medicine: Medicine, user: String) {
        updateStock(medicine, by: -1, user: user)
    }
    
    private func updateStock(_ medicine: Medicine, by amount: Int, user: String) {
        DispatchQueue.global(qos: .background).async {
            
            self.manager.updateStock(medicine: medicine, by: amount) { result in
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success:
                        if let index = self.medicines.firstIndex(where: { $0.id == medicine.id }) {
                            let oldStock = self.medicines[index].stock
                            self.medicines[index].stock += amount
                            
                            self.addHistory(
                                action: "\(amount > 0 ? "Increased" : "Decreased") stock of \(medicine.name) by \(amount)",
                                user: user,
                                medicineId: medicine.id ?? "",
                                details: "Stock changed from \(oldStock) to \(oldStock + amount)"
                            )
                        }
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
    
    
    func updateMedicine(_ medicine: Medicine, user: String) {
        manager.updateMedicine(medicine: medicine) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.addHistory(action: "Updated \(medicine.name)",
                                    user: user,
                                    medicineId: medicine.id ?? "",
                                    details: "Updated medicine details")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func addHistory(action: String, user: String, medicineId: String, details: String) {
        let history = HistoryEntry(medicineId: medicineId, user: user, action: action, details: details)
        manager.addHistory(history: history) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("History added successfully.")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchHistory(for medicine: Medicine) {
        guard let medicineId = medicine.id else { return }
        manager.fetchHistory(for: medicineId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let historyEntries):
                    self.history = historyEntries
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
