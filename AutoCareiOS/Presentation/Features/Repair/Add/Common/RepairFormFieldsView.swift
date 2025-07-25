//
//  RepairFormFieldsView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 19.07.2025.
//

import Foundation
import SwiftUI


struct RepairFormFieldsView: View {
    
    @Binding var nameRepair: String
    @Binding var amountRepair: Int32?
    @Binding var mileageRepair: Int32?
    @Binding var dateOfRepair: Date
    @Binding var notesRepair: String
    @Binding var litresFuel: Double?
    @Binding var selectedCaregory: RepairCategory
    
    @FocusState.Binding var focusedField: Field?

    var body: some View {
        
        VStack(spacing: 20) {
            TextField("What did you do?", text: $nameRepair)
                .disableAutocorrection(true)
                .underlineTextField()
                .shadow(radius: 5)
                .focused($focusedField, equals: .nameRepair)
            
            RepairCategorySelectorView(selectedCaregory: $selectedCaregory)
            
            if selectedCaregory == .fuel {
                TextField("How many liters were poured?", value: $litresFuel, formatter: numberFormatterForLitres())
                    .keyboardType(.numberPad)
                    .disableAutocorrection(true)
                    .shadow(radius: 5)
                    .focused($focusedField, equals: .litresFuel)
            }
            
            TextField("Amount", value: $amountRepair, formatter: numberFormatterForCoast())
                .keyboardType(.numberPad)
                .onChange(of: amountRepair) { newValue in
                    if let newValue = newValue {
                        amountRepair = validForAmount(newValue)
                    }
                }
                .focused($focusedField, equals: .amountRepair)
            
            TextField("Mileage", value: $mileageRepair, formatter: numberFormatterForMileage())
                .keyboardType(.numberPad)
                .onChange(of: mileageRepair) { newValue in
                    if let newValue = newValue {
                        mileageRepair = validForMileage(newValue)
                    }
                }
                .focused($focusedField, equals: .mileageRepair)
            
            DatePicker("Date of repair", selection: $dateOfRepair, displayedComponents: [.date])
            
            TextField("Description (optional)", text: $notesRepair)
                .disableAutocorrection(true)
                .focused($focusedField, equals: .notes)
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
