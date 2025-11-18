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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Engine type")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
                
                Picker("Engine type", selection: $engineType) {
                    ForEach(EngineTypeEnum.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Transmission type")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
                
                Picker("Transmission", selection: $transmissionType) {
                    ForEach(TransmissionTypeEnum.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

#Preview {
    struct AddCarDetailsSection: View {
        @State var engineType: EngineTypeEnum = .diesel
        @State var transmissionType: TransmissionTypeEnum = .automatic

        var body: some View {
            AddCarDetailsSection(
                engineType: engineType,
                transmissionType: transmissionType)
        }
    }

    return AddCarDetailsSection()
}
