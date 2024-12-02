//
//  AddMedicineSheetView.swift
//  MediStock
//

import SwiftUI

struct AddMedicineSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: MedicineStockViewModel
    
    @State private var name: String = ""
    @State private var stock: Int = 0
    @State private var aisle: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Medicine Information")) {
                    TextField("Name", text: $name)
                    TextField("Stock", value: $stock, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    TextField("Aisle", text: $aisle)
                }
            }
            .navigationTitle("Add Medicine")
            .navigationBarItems(leading: Button("Cancel", action: {
                presentationMode.wrappedValue.dismiss()
            }), trailing: Button("Add") {
                viewModel.addMedicine(name: name, stock: stock, aisle: aisle)
                presentationMode.wrappedValue.dismiss()
            }
                .disabled(name.isEmpty || aisle.isEmpty || stock <= 0)
            )
        }
    }
}

#Preview {
    AddMedicineSheetView()
}
