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
    
    var body: some View {
        
        if carViewModel.allCars.isEmpty {
            
            EmptyCarList()
            
        } else {
            
            NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        VStack {
                            
                            if repairViewModel.repairArray.isEmpty {
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
                    repairViewModel.getAllRepairs(for: selectedCar)
                } else {
                    print("Repairs для автомобиля \(carViewModel.nameModel) не найдены.")
                }
            }
        }
    }
    
    private var filteredRepairs: [Repair] {
        if searchText.isEmpty {
            return repairViewModel.repairArray.reversed()
        } else {
            return repairViewModel.repairArray.filter { repair in
                repair.partReplaced!.lowercased().contains(searchText.lowercased())
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
        ForEach(filteredRepairs) { repair in
            NavigationLink(destination: DetailView(repair: repair)
                .onAppear { showTapBar = false }
                .onDisappear { showTapBar = true }) {
                ListRowView(repair: repair)
                    .padding(.vertical, 5)
            }
            .buttonStyle(PlainButtonStyle())
            .contextMenu {
                Button(action: {
                    repairViewModel.deleteRepair(repair)
                }) {
                    Text("Delete repair")
                    Image(systemName: "trash")
                }
            }
            Divider()
                .background(Color.gray)
        }
    }
    
    private var addButton: some View {
        HStack {
            Spacer()
            AddButtonRepairView(isPresented: $isPresented)
                .padding(.horizontal, 30)
                .padding(.bottom, 90)
        }
    }
}


//#Preview {
//    ListRepairView()
//        .environmentObject(RepairViewModel())
//        .environmentObject(CarViewModel())
//}
