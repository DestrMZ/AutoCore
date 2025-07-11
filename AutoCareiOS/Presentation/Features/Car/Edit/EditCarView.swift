//
//  EditCarView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 16.01.2025.
//

import SwiftUI
import PhotosUI

struct EditCarView: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var tempNameModel: String = ""
    @State private var tempYear: Int16? = nil
    @State private var tempVinNumber: String = ""
    @State private var tempMileage: Int32? = nil
    @State private var tempColor: String = ""
    @State private var tempEngineType: EngineTypeEnum = .gasoline
    @State private var tempTransmissionType: TransmissionTypeEnum = .manual
    
    @State private var selectionImageCar: PhotosPickerItem?
    @State private var avatarImage: UIImage?
    
    @State private var alertMessageVIN: Bool = false
    @FocusState var isKeyboardActive: Bool

    var editingForCar: CarModel?
    
    func initTemp() {
        if let car = editingForCar {
            tempNameModel = car.nameModel
            tempYear = car.year
            tempVinNumber = car.vinNumbers
            tempMileage = car.mileage
            tempColor = car.color ?? "Default color"
            tempEngineType = EngineTypeEnum(rawValue: car.engineType) ?? .gasoline
            tempTransmissionType = TransmissionTypeEnum(rawValue: car.transmissionType) ?? .automatic
            avatarImage = UIImage(data: car.photoCar)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                HStack { // IMAGE
                    PhotosPicker(selection: $selectionImageCar, matching: .images) {
                        
                        ZStack {
                            if let imageAvatar = avatarImage {
                                Image(uiImage: imageAvatar)
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 130, height: 130)
                                    .background(Color(.systemGray6))
                                    .clipShape(Circle())
                            } else {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 130, height: 130)
                                        .shadow(color: .purple.opacity(0.2), radius: 10, x: 0, y: 5)
                                    
                                    Image(systemName: "car.fill")
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 65, height: 65)
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }
                    .onChange(of: selectionImageCar) {newValue in
                        if let newValue = newValue {
                            newValue.loadTransferable(type: Data.self) {
                                result in
                                switch result {
                                case.success(let imageData):
                                    if let imageData = imageData, let image = UIImage(data: imageData) {
                                        self.avatarImage = image
                                    }
                                case.failure(_):
                                    print("Ошибка добавления изображения!")
                                }
                            }
                        }
                    }
                }
                .padding(.top, 10)
                
                
                VStack(alignment: .center, spacing: 16) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Model")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "car.circle")
                                .foregroundStyle(.secondary)
                                .frame(width: 10)
                            
                            TextField("Model", text: $tempNameModel)
                                .focused($isKeyboardActive)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Year")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "calendar")
                                .foregroundStyle(.secondary)
                                .frame(width: 10)
                            
                            TextField("Year", value: $tempYear, formatter: NumberFormatter())
                                .focused($isKeyboardActive)
                                .keyboardType(.numberPad)
                                .onChange(of: tempYear) { newValue in
                                    if let newValue = newValue {
                                        tempYear = validForYear(newValue)
                                    }
                                }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("VIN")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "gearshape.2.fill")
                                .foregroundStyle(.secondary)
                                .frame(width: 10)
                            
                            TextField("VIN-Number", text: $tempVinNumber)
                                .focused($isKeyboardActive)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mileage")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "speedometer")
                                .foregroundStyle(.secondary)
                                .frame(width: 10)
                            
                            TextField("Mileage", value: $tempMileage, formatter: NumberFormatter())
                                .focused($isKeyboardActive)
                                .keyboardType(.numberPad)
                                .onChange(of: tempMileage) { newValue in
                                    if let newValue = newValue {
                                        tempMileage = validForMileage(newValue)
                                    }
                                }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Color")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.secondary)
                        
                        HStack(spacing: 12) {
                            Image(systemName: "paintpalette.fill")
                                .foregroundStyle(.secondary)
                                .frame(width: 10)
                            
                            TextField("Color", text: $tempColor)
                                .focused($isKeyboardActive)
                        }
                    }
                    
                    CustomPickerField(title: "Engine type", icon: "engine.combustion", selection: $tempEngineType)
                    CustomPickerField(title: "Transmission type", icon: "gearshape.2.fill", selection: $tempTransmissionType)
                    
                }
                .padding()
                .onAppear {
                    initTemp()
                }
                
            }
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//                
//                ToolbarItem(placement: .confirmationAction) {
//                    Button(action: {
//                        
//                        if let car = editingForCar {
//                            
//                            carViewModel.updateCar(carModel: CarModel(
//                                id: car.id,
//                                nameModel: tempNameModel,
//                                year: tempYear,
//                                engineType: tempEngineType,
//                                transmissionType: tempTransmissionType,
//                                mileage: tempMileage,
//                                photoCar: avatarImage,
//                                vinNumbers: tempVinNumber))
//
//                        }
//                    }) {
//                        Text("Save")
//                    }.disabled(isFormIncomplete(nameModel: tempNameModel, vinNumber: tempVinNumber, year: tempYear, mileage: tempMileage))
//                }
//                
//                ToolbarItem(placement: .keyboard) {
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                            isKeyboardActive = false
//                        }) {
//                            Image(systemName: "keyboard.chevron.compact.down")
//                        }
//                    }
//                }
//            }
//            .navigationBarTitle(NSLocalizedString("Edit car", comment: ""), displayMode: .inline)
        }
        .cornerRadius(12)
        .shadow(radius: 5)
        
        .alert(isPresented: $alertMessageVIN) {
            Alert(
                title: Text("Oops"),
                message: Text("This VIN number already exists"),
                dismissButton: .default(Text("Okey"))
                )
        }
    }
}


//#Preview {
//    EditCarView()
//        .environmentObject(CarViewModel())
//}
