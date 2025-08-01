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
    
    let container: AppDIContainer
    
    @Environment(\.dismiss) var dismiss

    @StateObject var addRepairViewModel: AddRepairViewModel
    @State private var showSuccessMessage: Bool = false
    
    @FocusState var focusedField: Field?
    
    init(container: AppDIContainer) {
        self._addRepairViewModel = StateObject(wrappedValue: AddRepairViewModel(repairUseCase: container.repairUseCase, sharedRepairStore: container.sharedRepair))
    }
 
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    RepairFormFieldsView(
                        nameRepair: $addRepairViewModel.nameRepair,
                        amountRepair: $addRepairViewModel.amountRepair,
                        mileageRepair: $addRepairViewModel.mileageRepair,
                        dateOfRepair: $addRepairViewModel.dateRepair,
                        notesRepair: $addRepairViewModel.notesRepiar,
                        litresFuel: $addRepairViewModel.litresRepair,
                        selectedCaregory: $addRepairViewModel.categoryRepair, focusedField: $focusedField)
                    
                    RepairPartsListView(addRepairViewModel: addRepairViewModel, parts: $addRepairViewModel.partsRepair)
                    
                    RepairPhotoPickerView(
                        photoRepair: $addRepairViewModel.photoRepair,
                        showSuccessMessage: $showSuccessMessage)
                    
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save", action: {
                            if let car = carViewModel.selectedCar {
                                addRepairViewModel.addRepair(for: car)
                            }
                            
                            if !addRepairViewModel.alertShow {
                                dismiss()
                            }
                        })
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
        .alert(isPresented: $addRepairViewModel.alertShow) {
            Alert(title: Text("Ops"), message: Text(addRepairViewModel.alertMessage), dismissButton: .cancel())
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
}


#Preview {
    let mockRepair = RepairModel(
        id: UUID(),
        amount: 15000,
        litresFuel: 0,
        notes: "Замена масла и фильтров",
        partReplaced: "Масляный фильтр",
        parts: ["F123": "Фильтр", "F124": "Масло"],
        photoRepairs: nil,
        repairCategory: RepairCategory.service.rawValue,
        repairDate: Date(),
        repairMileage: 120000
    )
    
    let mockCar = CarModel(
        id: UUID(),
        nameModel: "Toyota Corolla",
        year: 2015,
        color: "Белый",
        engineType: "gasoline",
        transmissionType: "automatic",
        mileage: 120000,
        photoCar: Data(),
        vinNumbers: "JTDBL40E799999999",
        repairs: [mockRepair],
        insurance: nil,
        stateNumber: "А123ВС"
    )
    
    let mockCarVM = CarViewModel(carUseCase: CarUseCase(carRepository: MockCarRepository(), userStoreRepository: UserStoreRepository()))
    let mockRepairVM = RepairViewModel(repairUseCase: RepairUseCase(repairRepository: MockRepairRepository()))
    
    let container = AppDIContainer()
    
    AddRepairView(container: container)
        .environmentObject(mockCarVM)
        .environmentObject(mockRepairVM)
}

