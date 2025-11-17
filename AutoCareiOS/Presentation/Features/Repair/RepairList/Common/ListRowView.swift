//
//  ListRepairView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 14.10.2024.
//

import SwiftUI

struct ListRowView: View {
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var repair: RepairModel
    
    var body: some View {
        
        VStack {
            HStack {
                if let repairCategory = RepairCategory(rawValue: repair.repairCategory) {
                    ZStack {
                        Image(repairCategory.imageIcon)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.primary)
                            .frame(width: 26, height: 26)
                            .padding(.trailing, 8)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(repair.partReplaced)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(repair.amount,
                         format: .currency(code: settingsViewModel.currency)
                             .presentation(.narrow)
                             .rounded(rule: .awayFromZero, increment: 1))
                        .font(.subheadline.weight(.semibold).monospacedDigit())
                        .foregroundStyle(.secondary)

                    Text("Due: \(repair.repairDate.formatted(.dateTime.month(.abbreviated).day().year()))")
                        .font(.footnote)
                        .foregroundStyle(.tertiary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
        }
    }
}

#Preview {
    let exampleRepair = RepairModel(
        id: UUID(),
        amount: 200,
        litresFuel: nil,
        notes: "Changed brake pads",
        partReplaced: "Brake Pads",
        parts: [:],
        photoRepairs: nil,
        repairCategory: RepairCategory.other.rawValue,
        repairDate: Date(),
        repairMileage: 15000
    )
    
    let anotherRepair = RepairModel(
        id: UUID(),
        amount: 50,
        litresFuel: nil,
        notes: "Engine oil change",
        partReplaced: "Engine Oil",
        parts: [:],
        photoRepairs: nil,
        repairCategory: RepairCategory.service.rawValue,
        repairDate: Date().addingTimeInterval(-86400),
        repairMileage: 30000
    )
    
    let settingsVM = SettingsViewModel()
    
    return List {
        ListRowView(repair: exampleRepair)
            .environmentObject(settingsVM)
        ListRowView(repair: anotherRepair)
            .environmentObject(settingsVM)
    }
}
