//
//  MedicineStock.swift
//  MediStock
//

import SwiftUI

struct MedicineStock: View {
    @Binding var medicine: Medicine
    @EnvironmentObject var viewModel: MedicineStockViewModel
    @EnvironmentObject var session: SessionViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Stock")
                .font(.headline)
            HStack {
                Button(action: {
                    viewModel.decreaseStock(medicine, user: session.session?.uid ?? "")
                }) {
                    Image(systemName: "minus.circle")
                        .font(.title)
                        .foregroundColor(.red)
                }
                TextField("Stock", value: $medicine.stock, formatter: NumberFormatter(), onCommit: {
                    viewModel.updateMedicine(medicine, user: session.session?.uid ?? "")
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .frame(width: 100)
                Button(action: {
                    viewModel.increaseStock(medicine, user: session.session?.uid ?? "")
                }) {
                    Image(systemName: "plus.circle")
                        .font(.title)
                        .foregroundColor(.green)
                }
            }
            .padding(.bottom, 10)
        }
        .padding(.horizontal)
    }
}

#Preview {
    @Previewable @State var sampleMedicine = Medicine(name: "Sample", stock: 10, aisle: "Aisle 1")
    MedicineStock(medicine: $sampleMedicine)
        .environmentObject(SessionViewModel())
        .environmentObject(MedicineStockViewModel())
}
