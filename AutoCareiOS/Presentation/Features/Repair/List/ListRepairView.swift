//
//  RepairListView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 12.10.2024.
//

import SwiftUI


struct ListRepairView: View {
    
    let container: AppDIContainer
    
    @StateObject var listRepairViewModel: ListRepairViewModel
    
    @State var searchText: String = ""
    @State private var searchBarHeight: CGFloat = 0
    @State var isPresented: Bool = false
    @State private var isExpanded = true
    
    @Binding var showTapBar: Bool
    
    init(container: AppDIContainer, showTapBar: Binding<Bool>) {
        self._listRepairViewModel = StateObject(wrappedValue: ListRepairViewModel(
            repairUseCase: container.repairUseCase,
            sharedRepairStore: container.sharedRepair))
        self._showTapBar = showTapBar
    }
    
    var body: some View {
        
        if listRepairViewModel.repairs.isEmpty {
            EmptyRepairView()
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
                    AddRepairView(construct: container)
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
