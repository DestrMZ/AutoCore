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
            ScrollView {
                VStack(alignment: .leading) {
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
                    
                    Spacer()
                    
//                    HStack {
//                        Spacer()
//                        AddButtonRepairView(isPresented: $isPresented)
//                            .padding(.horizontal, 45)
//                    }
                }
                .padding(.horizontal, 15)
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
