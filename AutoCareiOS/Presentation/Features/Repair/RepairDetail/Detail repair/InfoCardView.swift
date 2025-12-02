//
//  InfoCardView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 12.04.2025.
//

import Foundation
import SwiftUI


struct InfoCardView: View {
    @Binding var isRepairEditing: Bool
    @Binding var cost: String
    @Binding var mileage: String
    @Binding var category: RepairCategory
    @Binding var notes: String
    let repair: RepairModel
    
    var body: some View {
        VStack(spacing: 10) {
            // Сумма
            InfoCard(
                icon: "banknote.fill",
                title: NSLocalizedString("Amount", comment: "AmountENG"),
                value: isRepairEditing ? nil : "\(repair.amount) ₽",
                color: .primary,
                inputType: .value($cost),
                isEditing: isRepairEditing
            )
            
            // Пробег
            InfoCard(
                icon: "gauge",
                title: NSLocalizedString("Mileage", comment: "InfoCard"),
                value: isRepairEditing ? nil : "\(repair.repairMileage) mi",
                color: .primary,
                inputType: .value($mileage),
                isEditing: isRepairEditing
            )
            
            // Категория
            InfoCard(
                icon: "tag.fill",
                title: NSLocalizedString("Category", comment: "InfoCard"),
                value: isRepairEditing ? nil : NSLocalizedString(repair.repairCategory, comment: "InfoCard"),
                color: .primary,
                inputType: .picker($category),
                isEditing: isRepairEditing
            )
            
            // Описание (только если есть или редактируем)
            if isRepairEditing || !(repair.notes?.isEmpty ?? true) {
                InfoCard(
                    icon: "text.alignleft",
                    title: NSLocalizedString("Description", comment: "InfoCard"),
                        value: isRepairEditing ? nil : repair.notes ?? "",
                    color: .primary,
                    inputType: .text($notes),
                    isEditing: isRepairEditing
                )
            }
        }
    }
}


struct InfoCard: View {
    let icon: String
    let title: String
    let value: String?
    let color: Color
    let inputType: InputType
    let isEditing: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 10)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if isEditing {
                    switch inputType {
                    case .text(let binding):
                        TextField("Enter description", text: binding)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                    case .value(let binding):
                        TextField("Enter value", text: binding)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                            .keyboardType(.numberPad)
                    case .picker(let binding):
                        Picker(NSLocalizedString("Categories", comment: ""), selection: binding) {
                            ForEach(RepairCategory.allCases, id: \.self) { category in
                                Text(NSLocalizedString(category.rawValue, comment: ""))
                                    .tag(category)
                            }
                        }
                        .pickerStyle(.menu)
                        .font(.body)
                        .fontWeight(.medium)
                    }
                } else {
                    Text(value ?? "")
                        .font(.body)
                        .fontWeight(.medium)
                }
            }
            .padding(.horizontal, 10)

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}


enum InputType {
    case text(Binding<String>)
    case value(Binding<String>)
    case picker(Binding<RepairCategory>)
}
