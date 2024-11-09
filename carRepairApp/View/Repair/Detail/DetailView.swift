//
//  DetailView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.11.2024.
//

import SwiftUI

struct DetailView: View {
    
    @EnvironmentObject var repairViewModel: RepairViewModel
    @State private var imageRepair: UIImage? = nil
    
    var repair: Repair
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Spacer()
                Text("Detail")
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding(20)
            
            HStack {
                Text("Name: ")
                    .font(.headline)
                Spacer()
                Text("\(repair.partReplaced ?? "Uknown part")")
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Text("Amount: ")
                    .font(.headline)
                Spacer()
                Text("\(repair.amount) RUB")
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Text("Mileage: ")
                    .font(.headline)
                Spacer()
                Text("\(repair.repairMileage) KM")
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Text("Category:")
                    .font(.headline)
                Spacer()
                Text("\(String(describing: repair.repairCategory))")
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Text("Date: ")
                    .font(.headline)
                Spacer()
                Text("\(repair.repairDate?.formatted(.dateTime.year().month().day()) ?? "")")
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Text("Description: ")
                    .font(.headline)
                Spacer()
                Text("\(repair.notes ?? "Option")")
                    .foregroundStyle(.secondary)
            }
            
            partsDetail
            
            VStack(alignment: .center) {
                if let imageRepair = imageRepair {
                    Image(uiImage: imageRepair)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 300)
                        .clipped()
                }
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 20)
        .onAppear {
            if let image = repairViewModel.getPhotoRepair(repair: repair) {
                imageRepair = image
                print("INFO: Изображение ремонта загружено")
            } else {
                print("Изображение ремонта не найдено")
            }
        }
    }
    
    var partsDetail: some View {
        VStack {
            
            HStack {
                Text("Parts")
                    .font(.headline)
            }
            
            if let parts = repair.parts {
                if !parts.isEmpty {
                    ForEach(Array(parts), id: \.key) { part in
                        HStack {
                            Text("Article: \(part.key)")
                                .font(.headline)
                                .onTapGesture {
                                    copyToClipboard(text: part.key) // Copy to clipboard
                                    provideHapticFeedback() // Tactile feedback
                                }
                            Spacer()
                            Text("Name: \(part.value)")
                        }
                    }
                }
            }
        }
    }
}



#Preview {
    let context = CoreDataManaged.shared.context
    
    let repair = Repair(context: context)
    repair.partReplaced = "Brake pads"
    repair.amount = 100_000
    repair.repairMileage = 123_000
    repair.repairDate = Date()
    repair.notes = "Brake pads were replaced"
    
    repair.parts = ["EF31": "Generator", "E531": "Generator", "6F31": "Generator", "EF41": "Generator"]
    
    repair.repairCategory = "Service"
    
    return DetailView(repair: repair)
        .environmentObject(RepairViewModel())
}
