//
//  NewCar.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 11.11.2024.
//

import SwiftUI
import PhotosUI

struct AddCarView: View {
    
    @StateObject private var vm: AddCarViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var avatarImage: UIImage?
    
    @FocusState private var isKeyboardActive: Bool
    
    init(carStore: CarStore) {
        self._vm = StateObject(wrappedValue: AddCarViewModel(carStore: carStore))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                CarCardView(
                    name: $vm.nameModel,
                    stateNumber: $vm.stateNumber,
                    vin: $vm.vinNumber,
                    mileage: $vm.mileageText,
                    avatarImage: $avatarImage)
                Divider()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        AddCarMainInfoSection(
                            nameModel: $vm.nameModel,
                            year: $vm.yearText,
                            vinNumber: $vm.vinNumber,
                            stateNumber: $vm.stateNumber,
                            mileage: $vm.mileageText)
                        .focused($isKeyboardActive)

                        AddCarDetailsSection(
                            engineType: $vm.engineType,
                            transmissionType: $vm.transmissionType,
                            color: $vm.color)
                        .focused($isKeyboardActive)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let avatarImage, let data = avatarImage.jpegData(compressionQuality: 1) {
                            vm.photoData = data
                        }
                        
                        vm.saveCar()
                        
                        if !vm.isShowAlert {
                            dismiss()
                            
                        }
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        
                    }
                }
                
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button {
                            isKeyboardActive = false
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                    }
                }
            }
            .alert(isPresented: $vm.isShowAlert) {
                Alert(
                    title: Text("Notice"),
                    message: Text(vm.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    let mockRepository = MockCarRepository()
    let mockUser = UserStoreRepository()
    
    let mockUseCase = CarUseCase(carRepository: mockRepository, userStoreRepository: mockUser)
    
    
    let carStore = CarStore(carUseCase: mockUseCase)
    
    
    AddCarView(carStore: carStore)
}
