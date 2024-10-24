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
    
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    List {
                        if repairViewModel.repairArray.isEmpty {
                            Text("Repair list is empty.")
                                .font(.headline)
                                .bold()
                        } else {
                            ForEach(repairViewModel.repairArray) { repair in
                                NavigationLink(destination: DetailRepairView(repair: repair)) {
                                    ListRowView(repair: repair)
                                        .padding(.vertical, 5)
                                }
                                .contextMenu {
                                    Button(action: {
                                        repairViewModel.deleteRepair(repair)
                                    }) {
                                        Text("Delete repair")
                                        Image(systemName: "trash")
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                }
                
                Spacer()
                
                AddButtonRepairView(isPresented: $isPresented)
                
            }
        }
        .navigationBarTitle("Repairs", displayMode: .inline)
        .sheet(isPresented: $isPresented) {
            if carViewModel.selectedCar != nil {
                AddRepairView()
            }
        }
        .onAppear {
            if let selectedCar = carViewModel.selectedCar {
                repairViewModel.getAllRepair(for: selectedCar)
            } else {
                print("Car not found (ListRepairView")
            }
        }
    }
}

#Preview {
    ListRepairView()
        .environmentObject(RepairViewModel())
        .environmentObject(CarViewModel())
}
