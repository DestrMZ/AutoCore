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
    
    @State private var selectedImagesRepair: [PhotosPickerItem] = []
    
    @State private var nameRepair: String = ""
    @State private var amountRepair: Int32? = nil
    @State private var mileageRepair: Int32? = nil
    @State private var dateOfRepair: Date = Date()
    @State private var notesRepair: String = ""
    @State private var photoRepair: [Data] = []
    @State private var repairCategory: RepairCategory = .service
    @State private var parts: [Part] = [Part(article: "", name: "")]

    @State private var showSuccessMessage: Bool = false
        
    var body: some View {
        
        NavigationStack {
            ScrollView {
                formView
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                if let selectedCar = carViewModel.selectedCar {
                                    
                                    repairViewModel.createNewRepair(
                                        for: selectedCar,
                                        partReplaced: nameRepair,
                                        amount: amountRepair,
                                        repairDate: dateOfRepair,
                                        repairMileage: mileageRepair,
                                        notes: notesRepair,
                                        photoRepair: photoRepair,
                                        repairCategory: repairCategory,
                                        partsDict: repairViewModel.savePart(parts: parts))
                                    
                                    dismiss()
                                }
                            }.disabled(nameRepair.isEmpty || amountRepair ?? 0 <= 0 || mileageRepair ?? 0 <= 0)
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
        .toast(isPresenting: $showSuccessMessage) {
            AlertToast(
                displayMode: .banner(.pop),
                type: .complete(.black),
                title: "Good!",
                subTitle: "Photo's added",
                style: .style(backgroundColor: .blackRed.opacity(0.3),
                              titleColor: .black,
                              subTitleColor: .black,
                              titleFont: .headline,
                              subTitleFont: .subheadline))
            
        }
    }
    
    var formView: some View {
        
        VStack(spacing: 20) {
            TextField("Name repair", text: $nameRepair)
                .disableAutocorrection(true)
                .underlineTextField()
                .shadow(radius: 5)
            
            selectCategory // <- Select category
            
            TextField("Amount", value: $amountRepair, formatter: numberFormatterForCoast())
                .keyboardType(.decimalPad)
                .onChange(of: amountRepair) {newValue in
                    if let newValue = newValue {
                        amountRepair = validForAmount(newValue)
                    } else { amountRepair = nil}
                }
 
            TextField("Mileage", value: $mileageRepair, formatter: numberFormatterForMileage())
                .keyboardType(.numberPad)
                .onChange(of: mileageRepair) {newValue in
                    if let newValue = newValue {
                        mileageRepair = validForMileage(newValue)
                    } else { mileageRepair = nil }
                }
      
            DatePicker("Date of repair", selection: $dateOfRepair, displayedComponents: [.date])
            
            TextField("Description (optional)", text: $notesRepair)
                .disableAutocorrection(true)
                
            partsRow // MARK: Adding parts view
            

            HStack {
                Text("Photo")
                Spacer()
                PhotosPicker(selection: $selectedImagesRepair, matching: .images, photoLibrary: .shared()) {
                    Image(systemName: "photo.badge.plus")
                        .font(.largeTitle)
                        .foregroundStyle(.dimGray)
                }
                .onChange(of: selectedImagesRepair) {_ in
                    Task {
                        for image in selectedImagesRepair {
                            if let data = try? await image.loadTransferable(type: Data.self) {
                                DispatchQueue.main.async {
                                    self.photoRepair.append(data)
                                    self.showSuccessMessage = true
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .padding(.vertical, 25)
    }
    
    var partsRow: some View {
        VStack(alignment: .leading) {
            Text("Parts:")
            ForEach(parts.indices, id: \.self) { index in // indices - диапазон индексов в массиве
                HStack {
                    PartsRowView(part: $parts[index])
                    
                    if index == 0 {
                        Button(action: {
                            repairViewModel.addPart(for: &parts)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(.green)
                        }
                    } else {
                        Button(action: {
                            repairViewModel.removePart(for: &parts, to: index)
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
                        repairCategory = category
                    }) {
                        VStack {
                            Image(category.imageIcon)
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(repairCategory == category ? Color.primary : Color.secondary)
                            
                            Text(category.rawValue)
                                .font(.caption)
                                .foregroundColor(repairCategory == category ? Color.primary : Color.secondary)
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


struct AddButtonRepairView: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(action: {
            isPresented = true
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.red)
        }
    }
}

#Preview {
    AddRepairView()
        .environmentObject(CarViewModel())
        .environmentObject(RepairViewModel())
}

