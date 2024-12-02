import SwiftUI

struct AisleListView: View {
    @EnvironmentObject var viewModel: MedicineStockViewModel
    @State private var isPresentingAddMedicineSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.aisles, id: \.self) { aisle in
                    NavigationLink(destination: MedicineListView(aisle: aisle)) {
                        Text(aisle)
                    }
                }
            }
            .navigationBarTitle("Aisles")
            .navigationBarItems(trailing: Button(action: {
                isPresentingAddMedicineSheet = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $isPresentingAddMedicineSheet) {
                AddMedicineSheetView()
                    .environmentObject(viewModel)
            }
        }
        .onAppear {
            viewModel.fetchMedicines()
        }
    }
}

struct AisleListView_Previews: PreviewProvider {
    static var previews: some View {
        AisleListView()
    }
}
