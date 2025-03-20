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
    
    @FocusState var focusedField: Field?
        
    var body: some View {
        
        NavigationStack {
            ScrollView {
                formView
                    .onTapGesture {
                        hideKeyboard()
                    }
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
                displayMode: .hud,
                type: .complete(.white),
                title: NSLocalizedString("Good", comment: ""),
                subTitle: NSLocalizedString("Photo's uploaded", comment: ""),
                style: .style(backgroundColor: .black.opacity(0.7),
                              titleColor: .white,
                              subTitleColor: .white,
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
                .focused($focusedField, equals: .nameRepair)
            
            selectCategory // <- Select category
            
            TextField("Amount", value: $amountRepair, formatter: numberFormatterForCoast())
                .keyboardType(.decimalPad)
                .onChange(of: amountRepair) {newValue in
                    if let newValue = newValue {
                        amountRepair = validForAmount(newValue)
                    } else { amountRepair = nil}
                }
                .focused($focusedField, equals: .amountRepair)
 
            TextField("Mileage", value: $mileageRepair, formatter: numberFormatterForMileage())
                .keyboardType(.numberPad)
                .onChange(of: mileageRepair) {newValue in
                    if let newValue = newValue {
                        mileageRepair = validForMileage(newValue)
                    } else { mileageRepair = nil }
                }
                .focused($focusedField, equals: .mileageRepair)
      
            DatePicker("Date of repair", selection: $dateOfRepair, displayedComponents: [.date])
            
            TextField("Description (optional)", text: $notesRepair)
                .disableAutocorrection(true)
                .focused($focusedField, equals: .notes)
                
            partsRow // MARK: Adding parts view
            

            HStack {
                Text("Photo")
                Spacer()
                PhotosPicker(selection: $selectedImagesRepair, matching: .images, photoLibrary: .shared()) {
                    Image(systemName: "photo.badge.plus")
                        .font(.largeTitle)
                        .foregroundStyle(.blackRed)
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
            ForEach(parts.indices, id: \.self) { index in
                HStack {
                    PartsRowView(part: $parts[index])
                        .focused($focusedField, equals: .parts)
                    
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
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                        Button(action: {
                            hideKeyboard()
                        }) {
                            Image(systemName: "keyboard.chevron.compact.down")
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
                            
                            Text(NSLocalizedString(category.rawValue, comment: ""))
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

