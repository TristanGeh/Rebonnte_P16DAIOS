import SwiftUI

struct AllMedicinesView: View {
    @EnvironmentObject var viewModel: MedicineStockViewModel
    @State private var filterText: String = ""
    @State private var sortOption: SortOption = .none
    @State private var isPresentingAddMedicineSheet = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                // Filtrage et Tri
                HStack {
                    TextField("Filter by name", text: $filterText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, 10)
                        .onChange(of: filterText) {
                            viewModel.fetchDynamicMedicines(filter: filterText, sortOption: sortOption)
                        }
                    
                    Spacer()
                    
                    Picker("Sort by", selection: $sortOption) {
                        Text("None").tag(SortOption.none)
                        Text("Name").tag(SortOption.name)
                        Text("Stock").tag(SortOption.stock)
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.trailing, 10)
                    .onChange(of: sortOption) {
                        viewModel.fetchDynamicMedicines(filter: filterText, sortOption: sortOption)
                    }
                }
                .padding(.top, 10)
                
                // Liste des Médicaments
                List {
                    ForEach(viewModel.medicines, id: \.id) { medicine in
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
                .navigationBarTitle("All Medicines")
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
        }
        .onAppear {
            viewModel.fetchDynamicMedicines(filter: filterText, sortOption: sortOption)
        }
    }
}

struct AllMedicinesView_Previews: PreviewProvider {
    static var previews: some View {
        AllMedicinesView()
    }
}
