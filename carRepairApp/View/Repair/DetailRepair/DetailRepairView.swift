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
                
                HStack {
                    Text("Name ")
                        .font(.headline)
                    Spacer()
                    Text("\(repair.partReplaced ?? "Unknow part")")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Meleage:  ")
                        .font(.headline)
                    Spacer()
                    Text("\(repair.repairMileage) KM")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Amount ")
                        .font(.headline)
                    Spacer()
                    Text("\(repair.amount) RUB")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Date of repair:")
                        .font(.headline)
                    Spacer()
                    Text("\(repair.repairDate?.formatted(.dateTime.year().month().day()) ?? "Unknown date")")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Notes: ")
                        .font(.headline)
                    Spacer()
                    Text("\(repair.notes ?? "(Option)")")
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Photo of the repair:")
                        .font(.headline)
                        .padding(.top, 20)
                    
                    if let imageRepair = imageRepair {
                        Image(uiImage: imageRepair)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 200)
                            .clipped()
                    } else {
                        Text("Image not found")
                            .foregroundColor(.secondary)
                    }
                }
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
    repair1.amount = 200
    repair1.repairMileage = 123000
    repair1.repairDate = Date()
    repair1.notes = "Brake Pads were replaced"
    
    return DetailRepairView(repair: repair1)
        .environmentObject(RepairViewModel())
}
