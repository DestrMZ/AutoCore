//
//  RepairListView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 12.10.2024.
//

import SwiftUI

struct ListRepairView: View {
    
    @EnvironmentObject var repairViewModel: RepairViewModel
    
    @State var showAddNewSheet: Bool = false
    
    var body: some View {
        
        
        NavigationStack {
            VStack {
                List {
                    if repairViewModel.repairArray.isEmpty {
                        Text("Repair list is empty.")
                            .font(.headline)
                            .bold()
                    } else {
                        ForEach(repairViewModel.repairArray) { repair in
                            ListRowView(repair: repair)
                                .padding(.vertical, 20)
                        }
                    }
                }
            }
            .navigationBarTitle("Repairs", displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
                    showAddNewSheet.toggle()
                }) {
                    Text("Add")
                }
            )
            .sheet(isPresented: $showAddNewSheet) {
                AddRepairView()
                    .environmentObject(repairViewModel)
            }
        }
        .onAppear {
            if let car = repairViewModel.car {
                repairViewModel.getAllRepair(for: car)
            }
        }
    }
}

#Preview {
    ListRepairView()
        .environmentObject(RepairViewModel())
}
