//
//  AddRepair.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 13.10.2024.
//

import SwiftUI
import PhotosUI
import Combine

struct AddRepairView: View {
    
    @EnvironmentObject var repairViewModel: RepairViewModel
    @EnvironmentObject var carViewModel: CarViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var selectedImageRepair: PhotosPickerItem?
    @State var repairImage: UIImage?
    @State var showSuccessMessage: Bool = false
        
    var body: some View {
        
        NavigationStack {
            formView
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            if let selectedCar = carViewModel.selectedCar {
                                repairViewModel.createNewRepair(for: selectedCar)
                                dismiss()
                                print("Repair successfully saved for \(String(describing: selectedCar.nameModel))")
                            }
                        }.disabled(repairViewModel.partReplaced.isEmpty || repairViewModel.amount <= 0 || repairViewModel.repairMileage <= 0)
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
                .navigationBarTitle("Add repair", displayMode: .inline)
                .overlay(
                    Group {
                        if showSuccessMessage {
                            Text("Photo successfully uploaded!")
                                .foregroundColor(.green)
                                .transition(.opacity)
                                .animation(.easeInOut, value: showSuccessMessage)
                        }
                    }
                )
        }
    }
    
    var formView: some View {
        
        VStack {
            Form {
            TextField("Name repair", text: $repairViewModel.partReplaced)
                .disableAutocorrection(true)
            
            TextField("Amount", value: $repairViewModel.amount, formatter: numberFormatterForCoast())
                .keyboardType(.decimalPad)
            
            TextField("Mileage", value: $repairViewModel.repairMileage, formatter: numberFormatterForMileage())
                    .keyboardType(.numberPad)
      
            DatePicker("Date of repair", selection: $repairViewModel.repairDate, displayedComponents: [.date])
                
            TextField("Notes (optional)", text: $repairViewModel.notes)
                .disableAutocorrection(true)
            
                HStack {
                    Text("Photo")
                    Spacer()
                    PhotosPicker(selection: $selectedImageRepair, matching: .images) {
                        Image(systemName: "photo.badge.plus")
                            .font(.largeTitle)
                            .foregroundStyle(.dimGray)
                    }
                    .onChange(of: selectedImageRepair) { _, newItem in
                        if let newItem = newItem {
                            newItem.loadTransferable(type: Data.self) { result in
                                switch result {
                                case .success(let imageData):
                                    if let imageData = imageData {
                                        DispatchQueue.main.async {
                                            self.repairImage = UIImage(data: imageData)
                                            self.repairViewModel.photoRepair = imageData
                                        }
                                        self.showSuccessMessage = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            self.showSuccessMessage = false
                                        }
                                        print("Photo repair successfully uploaded")
                                    }
                                case .failure(let error):
                                    print("Error uploading photo repair: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    AddRepairView()
        .environmentObject(CarViewModel())
        .environmentObject(RepairViewModel())
}
