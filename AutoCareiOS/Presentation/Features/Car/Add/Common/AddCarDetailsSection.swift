//
//  AddCarDetailsSection.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 16.11.2025.
//

import SwiftUI

struct AddCarDetailsSection: View {
    
    @Binding var engineType: EngineTypeEnum
    @Binding var transmissionType: TransmissionTypeEnum
    @Binding var color: String
    
    @FocusState var isKeyboardActive: Bool
    
    var body: some View {
        Group {
            Picker("Engine type", selection: $engineType) {
                ForEach(EngineTypeEnum.allCases, id: \.self) { engineType in
                    Text(NSLocalizedString(engineType.rawValue.capitalized, comment: ""))
                        .tag(engineType)
                }
            }
            .pickerStyle(.navigationLink)
            
            Picker("Transmission type", selection: $transmissionType) {
                ForEach(TransmissionTypeEnum.allCases, id: \.self) { type in
                    Text(NSLocalizedString(type.rawValue.capitalized, comment: ""))
                        .tag(type)
                }
            }
            .pickerStyle(.navigationLink)
            
            TextField("Color", text: $color)
                .textFieldStyle(.roundedBorder)
                .focused($isKeyboardActive)
        }
    }
}

#Preview {
    struct AddCarDetailsSection: View {
        @State var engineType: EngineTypeEnum = .diesel
        @State var transmissionType: TransmissionTypeEnum = .automatic
        @State var color: String = "Black"

        var body: some View {
            AddCarDetailsSection(
                engineType: engineType,
                transmissionType: transmissionType,
                color: color)
        }
    }

    return AddCarDetailsSection()
}
