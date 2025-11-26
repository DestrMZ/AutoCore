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

@StateObject private var addRepairViewModel: AddRepairViewModel
@Environment(\.dismiss) private var dismiss

@FocusState var focusedField: Field?

@State private var showSuccessMessage: Bool = false

init(carStore: CarStore, repairStore: RepairStore) {
_addRepairViewModel = StateObject(wrappedValue: AddRepairViewModel(carStore: carStore, repairStore: repairStore))
}

var body: some View {
    NavigationStack {
        ScrollView {
            VStack(spacing: 20) {
                RepairFormFieldsView(
                    nameRepair: $addRepairViewModel.nameRepair,
                    amountRepair: $addRepairViewModel.amount,
                    mileageRepair: $addRepairViewModel.mileage,
                    dateOfRepair: $addRepairViewModel.date,
                    notesRepair: $addRepairViewModel.notes,
                    litresFuel: $addRepairViewModel.litres,
                    selectedCaregory: $addRepairViewModel.category,
                    focusedField: $focusedField)
                
                RepairPartsListView(addRepairViewModel: addRepairViewModel)
                
                RepairPhotoPickerView(
                    addRepairViewModel: addRepairViewModel)
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: {
                        addRepairViewModel.createRepair()
                        
                        if !addRepairViewModel.isShowAlert {
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
    .alert(isPresented: $addRepairViewModel.isShowAlert) {
        Alert(title: Text("Ops"), message: Text(addRepairViewModel.alertMessage), dismissButton: .cancel())
    }
    .toast(isPresenting: $addRepairViewModel.showSuccessMessage) {
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

