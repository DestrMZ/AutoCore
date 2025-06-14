//
//  CustomPickerField.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 21.01.2025.
//

import SwiftUI


struct CustomPickerField<T: RawRepresentable & CaseIterable & Hashable>: View where T.RawValue == String, T.AllCases: RandomAccessCollection {
    let title: String
    let icon: String
    @Binding var selection: T
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.secondary)
            
            Menu {
                Picker(title, selection: $selection) {
                    ForEach(T.allCases, id: \.self) { option in
                        Text(NSLocalizedString(option.rawValue.capitalized, comment: ""))
                            .tag(option)
                    }
                }
            } label: {
                HStack {
                    Image(systemName: icon)
                        .foregroundStyle(.secondary)
                        .frame(width: 20)
                    
                    Text(NSLocalizedString(selection.rawValue.capitalized, comment: ""))
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 14))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                )
                .buttonStyle(.plain)
            }
            .buttonStyle(.plain)
        }
    }
}
