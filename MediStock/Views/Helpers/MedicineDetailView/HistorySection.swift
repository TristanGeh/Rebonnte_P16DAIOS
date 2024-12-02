//
//  HistorySection.swift
//  MediStock
//

import SwiftUI

struct HistorySection: View {
    @State var medicine: Medicine
    @EnvironmentObject var viewModel: MedicineStockViewModel
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            Text("History")
                .font(.headline)
                .padding(.top, 20)
            ForEach(viewModel.history.filter { $0.medicineId == medicine.id }
                .sorted(by: { $0.timestamp > $1.timestamp }), id: \.id) { entry in
                VStack(alignment: .leading, spacing: 5) {
                    Text(entry.action)
                        .font(.headline)
                    Text("User: \(entry.user)")
                        .font(.subheadline)
                    Text("Date: \(entry.timestamp.formatted())")
                        .font(.subheadline)
                    Text("Details: \(entry.details)")
                        .font(.subheadline)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 5)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    let sampleMedicine = Medicine(name: "Sample", stock: 10, aisle: "Aisle 1")
    HistorySection(medicine: sampleMedicine)
        .environmentObject(MedicineStockViewModel())
}
