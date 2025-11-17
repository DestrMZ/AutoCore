//
//  AddCarMainInfoSection.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 16.11.2025.
//

import SwiftUI

struct AddCarMainInfoSection: View {
    
    @Binding var nameModel: String
    @Binding var year: Int16?
    @Binding var vinNumber: String
    @Binding var stateNumber: String
    @Binding var mileage: Int32?
    
    @FocusState var isKeyboardActive: Bool
    
    let yearFormatter: () -> NumberFormatter
    let mileageFormatter: () -> NumberFormatter
    let validYear: (Int16) -> Int16
    let validMileage: (Int32) -> Int32
    
    var body: some View {
        Group {
            TextField("Model", text: $nameModel)
                .textFieldStyle(.roundedBorder)
                .focused($isKeyboardActive)
            
            TextField("Year", value: $year, formatter: yearFormatter())
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .onChange(of: year) { newValue in
                    if let newValue {
                        year = validYear(newValue)
                    }
                }
                .focused($isKeyboardActive)
            
            TextField("VIN", text: $vinNumber)
                .textFieldStyle(.roundedBorder)
                .focused($isKeyboardActive)
            
            TextField("State number", text: $stateNumber)
                .textFieldStyle(.roundedBorder)
                .focused($isKeyboardActive)
            
            TextField("Mileage", value: $mileage, formatter: mileageFormatter())
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .onChange(of: mileage) { newValue in
                    if let newValue {
                        mileage = validMileage(newValue)
                    }
                }
                .focused($isKeyboardActive)
        }
    }
}

#Preview {
    struct AddCarMainInfoSectionPreviewWrapper: View {
        @State var nameModel: String = "Toyota Corolla"
        @State var year: Int16? = 2020
        @State var vinNumber: String = "JTNBB46K123456789"
        @State var stateNumber: String = "A123BC77"
        @State var mileage: Int32? = 45678

        var body: some View {
            AddCarMainInfoSection(
                nameModel: $nameModel,
                year: $year,
                vinNumber: $vinNumber,
                stateNumber: $stateNumber,
                mileage: $mileage,
                yearFormatter: yearFormatter,
                mileageFormatter: mileageFormatter,
                validYear: validForYear,
                validMileage: validForMileage
            )
        }
    }

    return AddCarMainInfoSectionPreviewWrapper()
}
