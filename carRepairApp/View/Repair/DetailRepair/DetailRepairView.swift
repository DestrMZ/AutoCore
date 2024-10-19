//
//  DetailRepairView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 17.10.2024.
//

import SwiftUI

struct DetailRepairView: View {
    
    @EnvironmentObject var repairViewModel: RepairViewModel
    
    var repair: Repair
    @State private var imageRepair: UIImage? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Form {
                
                Text("Name: \(repair.partReplaced ?? "Unknown part")")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                
                Text("Amount: \(repair.amount)")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                
                Text("Mileage: \(repair.repairMileage)")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                
                Text("Notes: \(repair.notes ?? "No notes")")
                
            }
            
            if let imageRepair = imageRepair {
                Image(uiImage: imageRepair)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
            } else {
                Text("Image not found")
            }

            
            Spacer()
            
        }
        .padding(.top, 25)
        .padding(.horizontal, 15)
        .navigationBarTitle("Detail info", displayMode: .inline)
        .onAppear {
            
            if let image = repairViewModel.getPhotoRepair(repair: repair) {
                imageRepair = image
                print("Изображение ремонта загружено")
            } else {
                print("Изображение ремонта не найдено")
            }
            
        }
    }
}

#Preview {
    let context = CoreDataManaged.shared.context
    
    let repair1 = Repair(context: context)
    repair1.partReplaced = "Brake Pads"
    repair1.amount = 200.0
    repair1.repairMileage = 123000
    repair1.repairDate = Date()
    
    return DetailRepairView(repair: repair1)
}
