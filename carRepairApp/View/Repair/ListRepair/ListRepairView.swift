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
                VStack {
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
        VStack {
            VStack(spacing: 8) {
                Text("🛠️ Go add your first expanses?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 1)
                Text("Take control of your car expenses effortlessly! Tap " + "+" + " to log each cost and keep everything on track.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .padding(.top, 300)
        }
        .frame(maxHeight: .infinity)
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
