//
//  ListRepairView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 14.10.2024.
//

import SwiftUI

struct ListRowView: View {
    
    @EnvironmentObject var repairViewModel: RepairViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var repair: Repair
    
    var body: some View {
        
        VStack {
            HStack {
                if let repairCategoryString = repair.repairCategory,
                    let repairCategory = RepairCategory(rawValue: repairCategoryString) {
                    Image(repairCategory.imageIcon)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.primary)
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 8)
                }
                
                VStack(alignment: .leading) {
                    
                    Text("\(repair.partReplaced ?? "Unknow part")")
                        .font(.title3)
                        .bold()
                        .lineLimit(1)
                    
                    Text("Amount: \(repair.amount.formatted()) \(settingsViewModel.currency)")
                        .font(.subheadline)
                        .lineLimit(1)
                    
                    Text("Due: \(repair.repairDate?.formatted(.dateTime.year().month().day()) ?? "Unknown date")")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                }
                
                Spacer()
                
                Image(systemName: "info.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
                    .shadow(color: Color.gray.opacity(0.3), radius: 2, x: 0, y: 2)
                    .offset(x: -5)
            }
        }
    }
}




#Preview {
    let context = CoreDataManaged.shared.context
    
    let exampleRepair = Repair(context: context)
    exampleRepair.partReplaced = "Brake Pads"
    exampleRepair.repairDate = Date()
    exampleRepair.amount = 200
    exampleRepair.repairMileage = 15000
    exampleRepair.repairCategory = RepairCategory.other.imageIcon
    
    let anotherRepair = Repair(context: context)
    anotherRepair.partReplaced = "Engine Oil"
    anotherRepair.repairDate = Date().addingTimeInterval(-86400)
    anotherRepair.amount = 50
    anotherRepair.repairMileage = 30000
    anotherRepair.repairCategory = RepairCategory.service.imageIcon
    
    let repairViewModel = RepairViewModel()
    
    return List {
        ListRowView(repair: exampleRepair)
            .environmentObject(repairViewModel)
        ListRowView(repair: anotherRepair)
            .environmentObject(repairViewModel)
    }
}
