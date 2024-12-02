import SwiftUI

struct MedicineDetailView: View {
    @State var medicine: Medicine
    @EnvironmentObject var viewModel: MedicineStockViewModel
    @EnvironmentObject var session: SessionViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text(medicine.name)
                    .font(.largeTitle)
                    .padding(.top, 20)

                // Medicine Name
                MedicineDetailTextFieldView(medicine: medicine, medicineInformation: "Name", text: $medicine.name)

                // Medicine Stock
                MedicineStock(medicine: $medicine)

                // Medicine Aisle
                MedicineDetailTextFieldView(medicine: medicine, medicineInformation: "Aisle", text: $medicine.aisle)

                // History Section
                HistorySection(medicine: medicine)
            }
            .padding(.vertical)
        }
        .navigationBarTitle("Medicine Details", displayMode: .inline)
        .onAppear {
            viewModel.fetchHistory(for: medicine)
        }
        .onChange(of: medicine) {
            viewModel.updateMedicine(medicine, user: session.session?.uid ?? "")
        }
    }
}

struct MedicineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMedicine = Medicine(name: "Sample", stock: 10, aisle: "Aisle 1")
        MedicineDetailView(medicine: sampleMedicine)
            .environmentObject(SessionViewModel())
            .environmentObject(MedicineStockViewModel())
    }
}
