//
//  RepairListView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 12.10.2024.
//

import SwiftUI


struct ListRepairView: View {
    
    @EnvironmentObject var repairViewModel: RepairViewModel
    
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
                                        .padding(.vertical, 20)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .padding(.horizontal, 0)
                }
                
                Spacer()
                
                AddButtonRepairView(isPresented: $isPresented)
                
            }
        }
        .navigationBarTitle("Repairs", displayMode: .inline)
        .sheet(isPresented: $isPresented) {
            AddRepairView()
        }
        .onAppear {
            repairViewModel.loadCar()
            if let car = repairViewModel.car {
                repairViewModel.getAllRepair(for: car)
            } else {
                print("Car not found, can't load repairs.")
            }
        }
    }
}

#Preview {
    ListRepairView()
        .environmentObject(RepairViewModel())
}
