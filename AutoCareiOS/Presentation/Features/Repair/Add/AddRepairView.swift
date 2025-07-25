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
    
    @State private var nameRepair: String = ""
    @State private var amountRepair: Int32? = nil
    @State private var mileageRepair: Int32? = nil
    @State private var dateOfRepair: Date = Date()
    @State private var notesRepair: String = ""
    @State private var litresFuel: Double? = nil
    @State private var photoRepair: [Data] = []
    @State private var repairCategory: RepairCategory = .service
    @State private var parts: [Part] = [Part(article: "", name: "")]
    @State private var showSuccessMessage: Bool = false
    
    @FocusState var focusedField: Field?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    RepairFormFieldsView(
                        nameRepair: $nameRepair,
                        amountRepair: $amountRepair,
                        mileageRepair: $mileageRepair,
                        dateOfRepair: $dateOfRepair,
                        notesRepair: $notesRepair,
                        litresFuel: $litresFuel,
                        selectedCaregory: $repairCategory, focusedField: $focusedField)
                    
                    RepairPartsListView(parts: $parts)
                    
                    RepairPhotoPickerView(
                        photoRepair: $photoRepair,
                        showSuccessMessage: $showSuccessMessage)
                    
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save", action: {
                            if let car = carViewModel.selectedCar {
                                repairViewModel.addRepair(for: car, repairModel: RepairModel(
                                    id: UUID(),
                                    amount: amountRepair ?? 0,
                                    litresFuel: litresFuel,
                                    notes: notesRepair,
                                    partReplaced: nameRepair,
                                    parts: repairViewModel.savePart(parts: parts),
                                    photoRepairs: photoRepair,
                                    repairCategory: repairCategory.rawValue,
                                    repairDate: dateOfRepair,
                                    repairMileage: mileageRepair ?? 0
                                ))
                                if !repairViewModel.alertShow {
                                    dismiss()
                                }
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
        .alert(isPresented: $repairViewModel.alertShow) {
            Alert(title: Text("Ops"), message: Text(repairViewModel.alertMessage), dismissButton: .cancel())
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
    
    
    AddRepairView()
        .environmentObject(mockCarVM)
        .environmentObject(mockRepairVM)
}

