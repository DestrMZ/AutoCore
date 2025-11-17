//
//  AddCarMainInfoSection.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 16.11.2025.
//

import SwiftUI

struct AddCarMainInfoSection: View {
    
    @Binding var nameModel: String
    @Binding var year: String
    @Binding var vinNumber: String
    @Binding var stateNumber: String
    @Binding var mileage: String
    
    @FocusState var isKeyboardActive: Bool
    
    var body: some View {
        Group {
            TextField("Model", text: $nameModel)
                .textFieldStyle(.roundedBorder)
                .focused($isKeyboardActive)
            
            TextField("Year", text: $year)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .focused($isKeyboardActive)
            
            TextField("VIN", text: $vinNumber)
                .textFieldStyle(.roundedBorder)
                .focused($isKeyboardActive)
            
            TextField("State number", text: $stateNumber)
                .textFieldStyle(.roundedBorder)
                .focused($isKeyboardActive)
            
            TextField("Mileage", text: $mileage)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .focused($isKeyboardActive)
        }
    }
}

#Preview {
    struct AddCarMainInfoSectionPreviewWrapper: View {
        @State var nameModel: String = "Toyota Corolla"
        @State var year: String = "2020"
        @State var vinNumber: String = "JTNBB46K123456789"
        @State var stateNumber: String = "A123BC77"
        @State var mileage: String = "45678"

        var body: some View {
            AddCarMainInfoSection(
                nameModel: $nameModel,
                year: $year,
                vinNumber: $vinNumber,
                stateNumber: $stateNumber,
                mileage: $mileage,
            )
        }
    }

    return AddCarMainInfoSectionPreviewWrapper()
}
