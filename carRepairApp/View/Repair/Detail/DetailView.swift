//
//  DetailView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.11.2024.
//

import SwiftUI

struct DetailView: View {
    
    @EnvironmentObject var repairViewModel: RepairViewModel
    @State private var imagesRepair: [UIImage]? = []
    @State private var currenctCopyMessage: Bool = false
    @State private var isTitleMessage: String = "Parts"
    
    var repair: Repair
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                HStack {
                    Spacer()
                    Text("Detail")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                .padding(20)
                
                VStack(alignment: .leading) {
                    Text("Name: ")
                        .font(.headline)
                        .bold()
                    Text("\(repair.partReplaced ?? "Uknown part")")
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading) {
                    Text("Amount: ")
                        .font(.headline)
                        .bold()
                    Text("\(repair.amount) RUB")
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading) {
                    Text("Mileage: ")
                        .font(.headline)
                        .bold()
                    Text("\(repair.repairMileage) KM")
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading) {
                    Text("Category:")
                        .font(.headline)
                        .bold()
                    Text("\(String(describing: repair.repairCategory ?? ""))")
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading) {
                    Text("Date: ")
                        .font(.headline)
                        .bold()
                    Text("\(repair.repairDate?.formatted(.dateTime.year().month().day()) ?? "")")
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading) {
                    Text("Description: ")
                        .font(.headline)
                        .bold()
                    Text("\(repair.notes ?? "Option")")
                        .foregroundStyle(.secondary)
                }
                
                Divider()
                
                partsDetail
                    .layoutPriority(1)
                
                Divider()
                
                VStack(alignment: .center) {
                    
                    HStack {
                        ScrollView {
                            if let imagesRepair = imagesRepair {
                                
                                ForEach(imagesRepair, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .clipped()
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
            }
            .padding(.horizontal, 20)
            .onAppear {
                if let repairImages = repairViewModel.getPhotosRepair(repair: repair) {
                    imagesRepair = repairImages
                    print("INFO: Изображения ремонта успешно загружены")
                } else {print("WARNING: Изображения ремонта не найдено")}
            }
        }
    }
    
    var partsDetail: some View {
        VStack {
            HStack {
                Text("\(isTitleMessage)")
                    .font(.headline)
            }
            if let parts = repair.parts {
                if !parts.isEmpty {
                    ForEach(Array(parts.sorted { $0.key < $1.key }), id: \.key) { part in
                        
                        VStack {
                            HStack {
                                Button(action: {
                                    copyToClipboard(text: part.key)
                                    provideHapticFeedback()
                                    isTitleMessage = "Article copy!"
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        isTitleMessage = "Parts"
                                    }
                                }) {
                                    Text("Article: \(part.key)")
                                        .font(.headline)
                                        .foregroundStyle(.black)
                                        .padding(5)
                                        .cornerRadius(5)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(.gray, style: StrokeStyle(lineWidth: 1.5)))
                                }
                                
                                Spacer()
                                
                                Text("\(part.value)")
                                    .font(.headline)
                                    .foregroundStyle(.black)
                            }
                        }
                        .padding(.vertical, 10)
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
