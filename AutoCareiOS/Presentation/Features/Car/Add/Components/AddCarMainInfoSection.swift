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
    @Binding var color: String
    
    @FocusState private var focusedField: Field?
    
    private enum Field: Hashable {
        case name, year, vin, stateNumber, mileage, color
    }
    
    var body: some View {
        VStack(spacing: 22) {
            CustomTextField(
                title: "Model",
                text: $nameModel,
                placeholder: "Hyundai Elantra",
                icon: "car.fill",
                isFocused: focusedField == .name
            )
            .focused($focusedField, equals: .name)
            
            CustomTextField(
                title: "Year",
                text: $year,
                placeholder: "2023",
                icon: "calendar",
                keyboardType: .numberPad,
                isFocused: focusedField == .year
            )
            .focused($focusedField, equals: .year)
            
            CustomTextField(
                title: "VIN",
                text: $vinNumber,
                placeholder: "Z94K241CBMR123456",
                icon: "doc.text.magnifyingglass",
                isFocused: focusedField == .vin
            )
            .focused($focusedField, equals: .vin)
            .textInputAutocapitalization(.characters)
            
            CustomTextField(
                title: "State number",
                text: $stateNumber,
                placeholder: "A777AA77",
                icon: "number",
                isFocused: focusedField == .stateNumber
            )
            .focused($focusedField, equals: .stateNumber)
            .textInputAutocapitalization(.characters)
            
            CustomTextField(
                title: "Mileage",
                text: $mileage,
                placeholder: "123 123",
                icon: "gauge.with.dots.needle.67percent",
                keyboardType: .numberPad,
                isFocused: focusedField == .mileage
            )
            .focused($focusedField, equals: .mileage)
            
            CustomTextField(
                title: "Color",
                text: $color,
                placeholder: "Phantom Black",
                icon: "paintpalette",
                isFocused: focusedField == .color
            )
            .focused($focusedField, equals: .color)
        }
        .animation(.easeInOut(duration: 0.2), value: focusedField)
    }
}


struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let icon: String
    var keyboardType: UIKeyboardType = .default
    var isFocused: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
            
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(isFocused ? .blue : .secondary)
                    .font(.system(size: 18))
                
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(isFocused ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
            .scaleEffect(isFocused ? 1.02 : 1.0)
            .shadow(color: isFocused ? .blue.opacity(0.3) : .clear, radius: 8, y: 4)
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
        @State var color: String = "Black"

        var body: some View {
            AddCarMainInfoSection(
                nameModel: $nameModel,
                year: $year,
                vinNumber: $vinNumber,
                stateNumber: $stateNumber,
                mileage: $mileage,
                color: $color
            )
        }
    }

    return AddCarMainInfoSectionPreviewWrapper()
}
