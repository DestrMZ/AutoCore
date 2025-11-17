//
//  HeaderView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 12.04.2025.
//

import Foundation
import SwiftUI


struct HeaderView: View {
    
    @Binding var isRepairEditing: Bool
    @Binding var partName: String
    @Binding var repairDate: Date
    
    let repair: RepairModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isRepairEditing {
                TextField("Enter a new name", text: $partName)
                    .font(.title)
                    .fontWeight(.bold)
                
                DatePicker(NSLocalizedString("Select a new date", comment: "Datail view"), selection: $repairDate, displayedComponents: [.date])
                    .datePickerStyle(.compact)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                Text(repair.partReplaced)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(repairDate.formatted(.dateTime.year().month().day()))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}


//#Preview {
//    let context = CoreDataManaged.shared.context
//    let repair = Repair(context: context)
//    repair.partReplaced = "Brake pads"
//    repair.repairDate = Date()
//    
//    return HeaderView(
//        isRepairEditing: .constant(true),
//        partName: .constant("Brake pads"),
//        repairDate: .constant(Date()),
//        repair: repair
//    )
//}




