import SwiftUI

struct MedicineListView: View {
    @EnvironmentObject var viewModel: MedicineStockViewModel
    @State private var isEditing = false
    @State private var selectedMedicines = Set<String>()
    var aisle: String
    
    var body: some View {
        List {
            ForEach(Array(viewModel.medicines.enumerated().filter { $0.element.aisle == aisle }), id: \.1.id) { index, medicine in
                
                HStack {
                    if isEditing {
                        Button {
                            toggleSelection(for: medicine)
                        } label: {
                            Image(systemName: selectedMedicines.contains(medicine.id ?? "") ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(.blue)
                                .background(Color(.white))
                        }
                        .buttonStyle(BorderedButtonStyle())
                        
                    }
                    
                    NavigationLink(destination: MedicineDetailView(medicine: medicine)) {
                        VStack(alignment: .leading) {
                            Text(medicine.name)
                                .font(.headline)
                            Text("Stock: \(medicine.stock)")
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(aisle)
        .navigationBarItems(
            trailing: Button(action: {
                if isEditing {
                    if !selectedMedicines.isEmpty {
                        viewModel.deleteMedicines(selectedMedicines, for: aisle)
                        selectedMedicines.removeAll()
                    }
                    isEditing = false
                } else {
                    isEditing = true
                }
            }) {
                Text(isEditing ? "Done" : "Edit")
            }
        )
    }
    private func toggleSelection(for medicine: Medicine) {
        guard let id = medicine.id else { return }
        if selectedMedicines.contains(id) {
            selectedMedicines.remove(id)
        } else {
            selectedMedicines.insert(id)
        }
    }
}


struct MedicineListView_Previews: PreviewProvider {
    static var previews: some View {
        MedicineListView(aisle: "Aisle 1")
            .environmentObject(SessionViewModel())
            .environmentObject(MedicineStockViewModel())
    }
}
