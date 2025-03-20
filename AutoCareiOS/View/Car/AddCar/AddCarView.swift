//
//  NewCar.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 11.11.2024.
//

import SwiftUI
import PhotosUI

struct AddCarView: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var tempNameModel: String = ""
    @State private var tempYear: Int16? = nil
    @State private var tempVinNumber: String = ""
    @State private var tempMileage: Int32? = nil
    @State private var tempEngineType: EngineTypeEnum = .gasoline
    @State private var tempTransmissionType: TransmissionTypeEnum = .manual
    
    @State private var selectionImageCar: PhotosPickerItem?
    @State private var avatarImage: UIImage?
    
    @State var buttonToNext: Bool = false
    @State var showAlert: Bool = false
    @State var alertMessageVIN: Bool = false
    
    @FocusState var isKeyboardActive: Bool
    
    var body: some View {
        
        NavigationStack {
            VStack {
                HStack {
                    Text("Add")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.primary)
                        .padding(.top, 10)
                    Image("newCar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                Divider()
            }
            
            broadScreen
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            
                            if let vinNumbers = carViewModel.getAllVinArray(), vinNumbers.contains(tempVinNumber) {
                                alertMessageVIN = true
                            } else {
                                carViewModel.createNewCar(
                                    nameModel: tempNameModel,
                                    year: tempYear,
                                    vinNumber: tempVinNumber,
                                    color: "",
                                    mileage: tempMileage,
                                    engineType: tempEngineType,
                                    transmissionType: tempTransmissionType,
                                    photoCar: avatarImage ?? UIImage()
                                )
                                dismiss()
                            }
                        }
                        .disabled(isFormIncomplete(nameModel: tempNameModel, vinNumber: tempVinNumber, year: tempYear, mileage: tempMileage))
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                    }
                    
                }
            }
        }
        .alert(isPresented: $alertMessageVIN) {
            Alert(
                title: Text("Oops"),
                message: Text("This VIN number already exists"),
                dismissButton: .default(Text("Okey"))
                )
        }
    }
    
    var broadScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                TextField("Model", text: $tempNameModel)
                    .textFieldStyle(.roundedBorder)
                    .focused($isKeyboardActive)
                
                TextField("Year", value: $tempYear, formatter: yearFormatter())
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .onChange(of: tempYear) {newValue in
                        if let newValue = newValue {
                            tempYear = validForYear(newValue)
                        } else { tempYear = nil }}
                    .focused($isKeyboardActive)
                
                TextField("VIN", text: $tempVinNumber)
                    .textFieldStyle(.roundedBorder)
                    .focused($isKeyboardActive)
                
                TextField("Mileage", value: $tempMileage, formatter: numberFormatterForMileage())
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .onChange(of: tempMileage) {newValue in
                        if let newValue = newValue {
                            tempMileage = validForMileage(newValue)
                        } else { tempVinNumber = ""}}
                    .focused($isKeyboardActive)
                
                Picker("Engine type", selection: $tempEngineType) {
                    ForEach(EngineTypeEnum.allCases, id: \.self) {
                        engineType in
                        Text(NSLocalizedString(engineType.rawValue.capitalized, comment: ""))
                            .tag(engineType)
                    }
                }
                .pickerStyle(.navigationLink)
                .foregroundStyle(.primary)
                
                Picker("Transmission type", selection: $tempTransmissionType) {
                    ForEach(TransmissionTypeEnum.allCases, id: \.self) { transmissionType in
                        Text(NSLocalizedString(transmissionType.rawValue.capitalized, comment: ""))
                            .tag(transmissionType)
                    }
                }
                .pickerStyle(.navigationLink)
                .foregroundStyle(.primary)
                
                VStack {
                    if let avatarImage = avatarImage {
                        Image(uiImage: avatarImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                
                Spacer()
                
                HStack() {
                    Spacer()
                    PhotosPicker(selection: $selectionImageCar, matching: .images) {
                        Label("Add photo", systemImage: "")
                            .frame(width: 110, height: 50)
                            .background(.blue)
                            .cornerRadius(10)
                            .foregroundStyle(.white)
                    
                    }
                    .onChange(of: selectionImageCar) {newValue in
                        if let newValue = newValue {
                            newValue.loadTransferable(type: Data.self) { result in
                                switch result {
                                case .success(let imageData):
                                    if let imageData = imageData, let image = UIImage(data: imageData) {
                                        self.avatarImage = image
                                    }
                                case .failure(_):
                                    print("Ошибка добавления фотографии авто!")
                                }
                                
                            }
                        }
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button(action: {
                            isKeyboardActive = false
                        }) {
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AddCarView()
        .environmentObject(CarViewModel())
}
