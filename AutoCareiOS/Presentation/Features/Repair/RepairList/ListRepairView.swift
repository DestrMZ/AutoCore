//
//  RepairListView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 12.10.2024.
//

import SwiftUI


struct ListRepairView: View {
    
    private let carStore: CarStore
    private let repairStore: RepairStore

    @StateObject private var repairListViewModel: RepairListViewModel
    
    @State private var searchText: String = ""
    @State private var searchBarHeight: CGFloat = 0
    @State private var isPresented: Bool = false

    @Binding var showTapBar: Bool

    private let tabBarHeight: CGFloat = 85
    
    init(carStore: CarStore, repairStore: RepairStore, showTapBar: Binding<Bool>) {
        self.carStore = carStore
        self.repairStore = repairStore
        _repairListViewModel = StateObject(wrappedValue: RepairListViewModel(carStore: carStore, repairStore: repairStore))
        _showTapBar = showTapBar
    }

    var body: some View {
        NavigationStack {
            Group {
                if repairListViewModel.selectedCar == nil {
                    EmptyCarsView()
                } else if repairListViewModel.repairs.isEmpty {
                    EmptyRepairView()
                } else {
                    ScrollView {
                        VStack(alignment: .center, spacing: 10) {
                            Text(repairListViewModel.selectedCar?.nameModel ?? "")
                                .font(.title3)
                                .foregroundColor(.secondary)
                                .bold()

                            SearchBar(
                                text: $searchText,
                                keyboardHeight: $searchBarHeight,
                                placeholder: NSLocalizedString("Search repair", comment: ""))

                            RepairGroupedListView(
                                groupedRepairs: repairListViewModel.groupedRepairs,
                                carStore: carStore,
                                repairStore: repairStore,
                                searchText: $searchText,
                                showTapBar: $showTapBar)
                            .padding(.bottom, 1)
                            .buttonStyle(.plain)            
                        }
                        .padding(.horizontal, 15)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            .overlay(alignment: .bottomTrailing) {
                if repairListViewModel.selectedCar != nil {
                    AddButtonView(isPresented: $isPresented)
                        .padding(.trailing, 25)
                        .padding(.bottom, 20 + (showTapBar ? tabBarHeight : 85))
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            AddRepairView(carStore: carStore, repairStore: repairStore)
        }
    }
}


//#Preview {
//    // Build dependencies for CarViewModel
//    let carRepositoryMock = MockCarRepository()
//    let userStoreRepository = UserStoreRepository()
//    let carUseCase = CarUseCase(carRepository: carRepositoryMock, userStoreRepository: userStoreRepository)
//    let carViewModel = CarViewModel(carUseCase: carUseCase)
//    
//    // Build dependencies for RepairViewModel
//    let repairRepositoryMock = MockRepairRepository()
//    let repairUseCase = RepairUseCase(repairRepository: repairRepositoryMock)
//    let repairViewModel = RepairViewModel(repairUseCase: repairUseCase)
//    
//    let repair2 = RepairModel(
//        id: UUID(),
//        amount: 3200,
//        litresFuel: 42.5,
//        notes: "Заправка АИ‑95",
//        partReplaced: "Топливо",
//        parts: [:],
//        photoRepairs: nil,
//        repairCategory: RepairCategory.fuel.rawValue,
//        repairDate: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
//        repairMileage: 124_100
//    )
//    
//    let repair = RepairModel(
//        id: UUID(),
//        amount: 8900,
//        litresFuel: nil,
//        notes: "Замена передних тормозных колодок",
//        partReplaced: "Тормозные колодки передние",
//        parts: ["BP-1234": "Колодки передние", "GR-001": "Смазка направляющих"],
//        photoRepairs: nil,
//        repairCategory: RepairCategory.service.rawValue,
//        repairDate: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(),
//        repairMileage: 123_450
//    )
//    
//    let car = CarModel(
//        id: UUID(),
//        nameModel: "Toyota Corolla",
//        year: 2015,
//        color: "White",
//        engineType: "gasoline",
//        transmissionType: "automatic",
//        mileage: 124_500,
//        photoCar: Data(),
//        vinNumbers: "JTDBL40E799999999",
//        repairs: [repair, repair2],
//        insurance: nil,
//        stateNumber: "A123BC"
//    )
//    
//    carViewModel.selectedCar = car
//    repairViewModel.repairs.append(repair)
//    
//    return ListRepairView(/*showTapBar: .constant(false)*/)
//        .environmentObject(repairViewModel)
//        .environmentObject(carViewModel)
//        .environmentObject(SettingsViewModel())
//}
