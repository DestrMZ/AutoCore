//
//  ListRepairView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 14.10.2024.
//

import SwiftUI

struct ListRowView: View {
    
    @EnvironmentObject var repairViewModel: RepairViewModel
    
    var repair: Repair
    
    var body: some View {
        
        VStack {
            
            HStack(spacing: 20) {
                
                VStack {
                    
                    Text(repair.partReplaced ?? "Unknow part")
                        .font(.subheadline)
                        .lineLimit(1)
                        .padding()
                    
                    Text("Due: \(repair.repairDate?.formatted() ?? "Unknown date")")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                    
                }
            }
        }
    }
}



//#Preview {
//    
//    ListRowView()
//        .environmentObject(RepairViewModel())
//}
