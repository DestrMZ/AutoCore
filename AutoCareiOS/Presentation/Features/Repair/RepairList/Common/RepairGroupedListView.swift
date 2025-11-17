//
//  RepairGroupedListView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 31.07.2025.
//

import Foundation
import SwiftUI

struct RepairGroupedListView: View {
    @EnvironmentObject var repairViewModel: RepairViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
        
    @Binding var searchText: String
    @Binding var showTapBar: Bool
    
    let selectedCar: CarModel?
    
    private var filteredRepairs: [RepairModel] {
            if searchText.isEmpty {
                return repairViewModel.repairs.reversed()
            } else {
                return repairViewModel.repairs.filter {
                    $0.partReplaced.lowercased().contains(searchText.lowercased())
                }
            }
        }
    
    var body: some View {
           let groups = repairViewModel.fetchRepairsGroupByMonth(for: filteredRepairs)

           ForEach(groups, id: \.id) { group in
               VStack(alignment: .leading, spacing: 0) {
                   HStack {
                       Text(group.monthTitle).font(.subheadline.weight(.semibold))
                       Spacer()
                       Text(group.totalAmount, format: .currency(code: "USD"))
                           .font(.subheadline.weight(.semibold).monospacedDigit())
                           .foregroundStyle(.secondary)
                   }
                   .padding(.horizontal, 2)
                   
//                   Divider()

                   ForEach(group.repairs) { repair in
                       if let car = selectedCar {
                           NavigationLink(
                               destination: DetailRepairView(repair: repair, car: car)
                                   .onAppear { showTapBar = false }
                                   .onDisappear { showTapBar = true }
                           ) {
                               ListRowView(repair: repair)
                                   .padding(.vertical, 7)
                                   .padding(.horizontal, 5)
                           }
                           .contextMenu {
                               Button("Delete repair") {
                                   repairViewModel.deleteRepair(repair: repair)
                           }
                       }
                   }
               }
           }
       }
   }
}


#Preview("RepairGroupedListView") {
    // Settings
    let settingsVM = SettingsViewModel()

    // Repair VM + мок юзкейс/репо
    let repairRepoMock = MockRepairRepository()
    let repairUseCase = RepairUseCase(repairRepository: repairRepoMock)
    let repairVM = RepairViewModel(repairUseCase: repairUseCase)

    // Пример машины
    let car = CarModel(
        id: UUID(),
        nameModel: "Hyundai Elantra",
        year: 2020,
        color: "White",
        engineType: "gasoline",
        transmissionType: "automatic",
        mileage: 42_000,
        photoCar: Data(),
        vinNumbers: "VINPREVIEW000000001",
        repairs: nil,
        insurance: nil,
        stateNumber: "A000AA"
    )

    // Примеры ремонтов (разные месяцы, чтобы показать группировку)
    let r1 = RepairModel(
        id: UUID(),
        amount: 2500,
        litresFuel: nil,
        notes: "Front brake pads replacement",
        partReplaced: "Brake Pads",
        parts: ["BP-1234": "Front pads kit"],
        photoRepairs: nil,
        repairCategory: RepairCategory.service.rawValue,
        repairDate: Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 23)) ?? Date(),
        repairMileage: 41_500
    )
    let r2 = RepairModel(
        id: UUID(),
        amount: 111,
        litresFuel: nil,
        notes: "Minor service",
        partReplaced: "Inspection",
        parts: [:],
        photoRepairs: nil,
        repairCategory: RepairCategory.other.rawValue,
        repairDate: Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 21)) ?? Date(),
        repairMileage: 41_300
    )
    let r3 = RepairModel(
        id: UUID(),
        amount: 3000,
        litresFuel: nil,
        notes: "Deep detailing",
        partReplaced: "Detailing",
        parts: ["DT-001": "Full package"],
        photoRepairs: nil,
        repairCategory: RepairCategory.service.rawValue,
        repairDate: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 6)) ?? Date(),
        repairMileage: 40_200
    )

    // Заполняем VM напрямую (не через fetch, чтобы превью не затиралось)
    repairVM.repairs = [r1, r2, r3]

    return NavigationStack {
        ScrollView {
            RepairGroupedListView(
                searchText: .constant(""),
                showTapBar: .constant(true),
                selectedCar: car
            )
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }
    .environmentObject(repairVM)
    .environmentObject(settingsVM)
}
