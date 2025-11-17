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
    @Binding var amountRepair: String
    @Binding var mileageRepair: String
    @Binding var dateOfRepair: Date
    @Binding var notesRepair: String
    @Binding var litresFuel: String
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
                TextField("How many liters were poured?", text: $litresFuel)
                    .keyboardType(.numberPad)
                    .disableAutocorrection(true)
                    .shadow(radius: 5)
                    .focused($focusedField, equals: .litresFuel)
            }
            
            TextField("Amount", text: $amountRepair)
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .amountRepair)
            
            TextField("Mileage", text: $mileageRepair)
                .keyboardType(.numberPad)
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
