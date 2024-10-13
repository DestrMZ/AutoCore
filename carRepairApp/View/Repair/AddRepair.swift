//
//  AddRepair.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 13.10.2024.
//

import SwiftUI
import PhotosUI

struct AddRepair: View {
    
    @EnvironmentObject var repairViewModel: RepairViewModel
    @EnvironmentObject var carViewModel: CarViewModel
    
    @State var selectinImageRepair: PhotosPickerItem?
    @State var repairImage: UIImage?
    @State var showSuccessMessage: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                VStack{
                    
                    HStack {
                        
                        Text("Add new repair")
                            .font(.title2)
                            .bold()
                        
                        Image(systemName: "car.fill")
                        
                    }
                    
                    Text("for \(carViewModel.nameModel)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                }
                
                Form {
                    TextField("Name repair", text: $repairViewModel.partReplaced)
                        .disableAutocorrection(true)
                    TextField("Amount", value: $repairViewModel.cost, formatter: numberFormatterForCoast())
                    TextField("Mileage", value: $repairViewModel.repairMileage, formatter: numberFormatterForMileage())
                    TextField("Notes", text: $repairViewModel.notes)
                    
                    DatePicker("Date of repair", selection: $repairViewModel.repairDate)
                    
                    HStack {
                        
                        Text("Add photo")
                        
                        Spacer()
                        
                        PhotosPicker(selection: $selectinImageRepair, matching: .images) {
                            
                            Image(systemName: "photo.badge.plus")
                                .font(.largeTitle)
                                .foregroundStyle(.dimGray)
                            
                        }
                    }
                    .onChange(of: selectinImageRepair) { oldItem, newItem in
                        if let newItem = newItem {
                            newItem.loadTransferable(type: Data.self) { result in
                                switch result {
                                case .success(let imageData):
                                    if let imageData = imageData, let image = UIImage(data: imageData) {
                                        self.repairImage = image
                                        self.showSuccessMessage = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            self.showSuccessMessage = false
                                        }
                                    }
                                case .failure(let error):
                                    print("Ошибка загрузки изображения ремонта: \(error.localizedDescription)")
                                    
                                }
                            }
                        }
                    }
                }
                
                Button(action: {
                    repairViewModel.createNewRepair()
                    print("Repair успешно добавлен")
                }) {
                    Text("Save repair")
                }
                
            }
            if showSuccessMessage {
                Text("Photo successfully uploaded!")
                    .foregroundColor(.green)
                    .transition(.opacity)
                    .animation(.easeInOut, value: showSuccessMessage)
            }
        }
    }
}




#Preview {
    AddRepair()
        .environmentObject(CarViewModel())
        .environmentObject(RepairViewModel())
}
