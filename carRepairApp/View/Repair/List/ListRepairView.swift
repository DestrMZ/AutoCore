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
                            
                            SearchBar(text: $searchText, keyboardHeight: $searchBarHeight, placeholder: "Search repair")

                            listRepairView
                                .padding(.bottom, 1)
                        }
                    }
                }
                .padding(.horizontal, 15)
            }
            
                if !repairViewModel.repairArray.isEmpty {
                    addButton
                }
        }
        }
        .navigationTitle("Repairs")
        .sheet(isPresented: $isPresented) {
            if carViewModel.selectedCar != nil {
                AddRepairView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let selectedCar = carViewModel.selectedCar {
                    repairViewModel.getAllRepair(for: selectedCar)
                } else {
                    print("Car not found (ListRepairView)")
                }
            }
        }
    }
    
    private var filteredRepairs: [Repair] {
        if searchText.isEmpty {
            return repairViewModel.repairArray
        } else {
            return repairViewModel.repairArray.filter { repair in
                repair.partReplaced!.lowercased().contains(searchText.lowercased())
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
