//
//  ListRepairView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 14.10.2024.
//

import SwiftUI

struct ListRowView: View {
    
    var repair: Repair
    
    var body: some View {
        
        VStack {
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text("\(repair.partReplaced ?? "Unknow part")")
                        .font(.title3)
                        .bold()
                        .lineLimit(1)
                    
                    Text("Amount: \(repair.cost.formatted())")
                        .font(.subheadline)
                        .lineLimit(1)
                    
                    Text("Due: \(repair.repairDate?.formatted() ?? "Unknown date")")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                }
            }
        }
    }
}




#Preview {
    let context = CoreDataManaged.shared.context
    
    let exampleRepair = Repair(context: context)
    exampleRepair.partReplaced = "Brake Pads"
    exampleRepair.repairDate = Date()
    exampleRepair.amount = 200.0
    exampleRepair.repairMileage = 15000
    
    let anotherRepair = Repair(context: context)
    anotherRepair.partReplaced = "Engine Oil"
    anotherRepair.repairDate = Date().addingTimeInterval(-86400)
    anotherRepair.amount = 50.0
    anotherRepair.repairMileage = 30000
    
    let repairViewModel = RepairViewModel()
    
    return List {
        ListRowView(repair: exampleRepair)
            .environmentObject(repairViewModel)
        ListRowView(repair: anotherRepair)
            .environmentObject(repairViewModel)
    }
}
