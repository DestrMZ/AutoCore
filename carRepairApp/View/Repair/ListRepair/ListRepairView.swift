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
                        emptyRepairList
                    } else {
                        listRepairView
                        
                    }
                }
                .padding(.horizontal, 15)
            }
            addButton
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
    
    private var emptyRepairList: some View {
        VStack(alignment: .leading) {
            if repairViewModel.repairArray.isEmpty {
                VStack {
                    Text("Repair list is empty.")
                        .font(.headline)
                        .bold()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    private var listRepairView: some View {
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
    
    private var addButton: some View {
        HStack {
            Spacer()
            AddButtonRepairView(isPresented: $isPresented)
                .padding(.horizontal, 30)
                .padding(.bottom, 90)
        }
    }
}


#Preview {
    ListRepairView()
        .environmentObject(RepairViewModel())
        .environmentObject(CarViewModel())
}
