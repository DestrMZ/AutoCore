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
    
    @State private var selectedImageRepair: PhotosPickerItem?
    @State private var repairImage: UIImage?
    @State private var showSuccessMessage: Bool = false
    
    @State private var isValidAmount: Bool = true
    @State private var isValidMileage: Bool = true
        
    var body: some View {
        
        NavigationStack {
            ScrollView {
                formView
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                if let selectedCar = carViewModel.selectedCar {
                                    repairViewModel.savePart()
                                    repairViewModel.createNewRepair(for: selectedCar)
                                    dismiss()
                                    print("Repair successfully saved for \(String(describing: selectedCar.nameModel))")
                                    print("Parts: \(repairViewModel.partsDictionary)")
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
                Spacer()
            }
        }
    }
    
    var formView: some View {
        
        VStack(spacing: 20) {
            TextField("Name repair", text: $repairViewModel.partReplaced)
                .disableAutocorrection(true)
                .underlineTextField()
                .shadow(radius: 5)
            
            selectCategory // <- Select category
            
            TextField("Amount", value: $repairViewModel.amount, formatter: numberFormatterForCoast())
                .keyboardType(.decimalPad)
                .onChange(of: repairViewModel.amount) {_, newValue in
                    repairViewModel.amount = validForAmount(newValue)}
 
            TextField("Mileage", value: $repairViewModel.repairMileage, formatter: numberFormatterForMileage())
                    .keyboardType(.numberPad)
                    .onChange(of: repairViewModel.repairMileage) {_, newValue in
                        repairViewModel.repairMileage = validForMileage(newValue)}
      
            DatePicker("Date of repair", selection: $repairViewModel.repairDate, displayedComponents: [.date])
            
            TextField("Description (optional)", text: $repairViewModel.notes)
                .disableAutocorrection(true)
                
            partsRow // MARK: Adding parts view
            
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
            
            if showSuccessMessage {
                Text("Photo successfully uploaded!")
                    .foregroundColor(.green)
                    .transition(.opacity)
                    .animation(.easeInOut, value: showSuccessMessage)
            }
    }
        .padding()
        .padding(.vertical, 25)
    }
    
    var partsRow: some View {
        VStack(alignment: .leading) {
            Text("Parts:")
            ForEach(repairViewModel.part.indices, id: \.self) { index in
                HStack {
                    PartsRowView(part: $repairViewModel.part[index])
                    
                    if index == 0 {
                        Button(action: {
                            repairViewModel.addPart()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(.green)
                        }
                    } else {
                        Button(action: {
                            repairViewModel.removePart(from: index)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
        }
    }
    
    var selectCategory: some View {
        
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 20) {
                ForEach(RepairCategory.allCases, id: \.self) { category in
                    Button(action: {
                        repairViewModel.repairCategory = category
                    }) {
                        VStack {
                            Image(category.imageIcon)
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(repairViewModel.repairCategory == category ? Color.black : Color.gray)
                            
                            Text(category.rawValue)
                                .font(.caption)
                                .foregroundColor(repairViewModel.repairCategory == category ? Color.black : Color.gray)
                        }
                    }
                }
            }
        }
    }
}

extension View {
    func underlineTextField() -> some View {
        self
            .padding()
            .overlay(Rectangle().frame(height: 1).padding(.top, 35).foregroundColor(.gray))
    }
}


#Preview {
    AddRepairView()
        .environmentObject(CarViewModel())
        .environmentObject(RepairViewModel())
}

