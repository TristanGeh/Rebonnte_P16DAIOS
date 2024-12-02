//
//  MedicineDetailTextFieldView.swift
//  MediStock
//

import SwiftUI

struct MedicineDetailTextFieldView: View {
    @State var medicine: Medicine
    @EnvironmentObject var viewModel: MedicineStockViewModel
    @EnvironmentObject var session: SessionViewModel
    
    var medicineInformation: String
    @Binding var text: String
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(medicineInformation)
                .font(.headline)
            TextField(medicineInformation, text: $text, onCommit: {
                viewModel.updateMedicine(medicine, user: session.session?.uid ?? "")
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.bottom, 10)
        }
        .padding(.horizontal)
    }
}

#Preview {
    @Previewable @State var sampleText = "Name"
    let sampleMedicine = Medicine(name: "Sample", stock: 10, aisle: "Aisle 1")
    MedicineDetailTextFieldView(medicine: sampleMedicine, medicineInformation: "Name", text: $sampleText)
        .environmentObject(SessionViewModel())
        .environmentObject(MedicineStockViewModel())
}
