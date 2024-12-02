import SwiftUI

struct MedicineListView: View {
    @EnvironmentObject var viewModel: MedicineStockViewModel
    @State private var isEditing = false
    var aisle: String

    var body: some View {
        List {
            ForEach(viewModel.medicines.filter { $0.aisle == aisle }, id: \.id) { medicine in
                
                HStack {
                    if isEditing {
                        Button {
                            viewModel.deleteMedicines(at: medicine)
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
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
        .navigationBarItems(trailing: Button(action: {
            isEditing.toggle()
        }, label: {
            Text( isEditing ? "Done" : "Edit")
        }))
    }
}

struct MedicineListView_Previews: PreviewProvider {
    static var previews: some View {
        MedicineListView(aisle: "Aisle 1")
            .environmentObject(SessionViewModel())
            .environmentObject(MedicineStockViewModel())
    }
}
