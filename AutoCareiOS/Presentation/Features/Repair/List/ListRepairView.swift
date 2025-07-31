//
//  RepairListView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 12.10.2024.
//

import SwiftUI


struct ListRepairView: View {
    
    @EnvironmentObject var repairViewModel: RepairViewModel
    @EnvironmentObject var carViewModel: CarViewModel
    
    @State var searchText: String = ""
    @State private var searchBarHeight: CGFloat = 0
    @Binding var showTapBar: Bool

    @State var isPresented: Bool = false
    @State private var isExpanded = true
    
    var body: some View {
        
        if carViewModel.cars.isEmpty {
            
//            EmptyCarList()
            
        } else {
            
            NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        VStack {
                            
                            if repairViewModel.repairs.isEmpty {
                                emptyRepairList
                            } else {
                                VStack {
                                    Text("\(carViewModel.nameModel)")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                        .padding(.bottom, 10)
                                    
                                    SearchBar(text: $searchText, keyboardHeight: $searchBarHeight, placeholder: NSLocalizedString("Search repair", comment: ""))
                                    
                                    listRepairView
                                        .padding(.bottom, 1)
                                }
                            }
                        }
                        .padding(.horizontal, 15)
                    }
                    
                    addButton
                }
            }
            .navigationTitle("Repairs")
            .sheet(isPresented: $isPresented) {
                if carViewModel.selectedCar != nil {
                    AddRepairView()
                }
            }
            .onAppear {
                if let selectedCar = carViewModel.selectedCar {
                    repairViewModel.fetchAllRepairs(for: selectedCar)
                } else {
                    print("Repairs для автомобиля \(carViewModel.nameModel) не найдены.")
                }
            }
        }
    }
    
    private var filteredRepairs: [RepairModel] {
        if searchText.isEmpty {
            return repairViewModel.repairs.reversed()
        } else {
            return repairViewModel.repairs.filter { repair in
                repair.partReplaced.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    private var emptyRepairList: some View {
        VStack(alignment: .center) {
            VStack(spacing: 8) {
                Text("🛠️ Go add your first expanses?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 1)
                Text(NSLocalizedString("car_expenses_control", comment: ""))
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .padding(.top, 300)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var listRepairView: some View {
        let groups = repairViewModel.fetchRepairsGroupByMonth(for: filteredRepairs)
        
        return ForEach(groups, id: \.id) { group in
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(group.monthTitle)
                        .font(.headline)
                    Spacer()
                    Text("\(String(format: "%.2f", group.totalAmount)) $")
                        .font(.subheadline)
                        .bold()
                }
                .padding(5)

                Divider()

                ForEach(group.repairs) { repair in
                    if let car = carViewModel.selectedCar {
                        NavigationLink(destination: DetailRepairView(repair: repair, car: car)
                            .onAppear { showTapBar = false }
                            .onDisappear { showTapBar = true }) {
                                ListRowView(repair: repair)
                                    .padding(.vertical, 7)
                            }
                            .contextMenu {
                                Button("Delete repair") {
                                    repairViewModel.deleteRepair(repair: repair)
                                
                            }
                    }
                    
                        
                    }
                
                }
            }
        }
    }

    
//    private var addButton: some View {
//        HStack {
//            Spacer()
//            AddButtonRepairView(isPresented: $isPresented)
//                .padding(.horizontal, 30)
//                .padding(.bottom, 90)
//        }
//    }
}


//#Preview {
//    ListRepairView()
//        .environmentObject(RepairViewModel())
//        .environmentObject(CarViewModel())
//}
