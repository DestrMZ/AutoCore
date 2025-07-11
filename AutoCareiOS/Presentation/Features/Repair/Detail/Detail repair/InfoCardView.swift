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
    @Binding var cost: Int?
    @Binding var mileage: Int?
    @Binding var category: RepairCategory
    @Binding var notes: String
    
    @State private var alertMessage: String = ""
    @State private var alertShow: Bool = false
    
    let repair: RepairModel
    
    var body: some View {
        VStack(spacing: 10) {
            
            InfoCard(
                icon: "banknote.fill",
                title: NSLocalizedString("Amount", comment: "AmountENG"),
                value: "\(repair.amount)",
                color: .primary,
                inputType: .value($cost),
                isEditing: $isRepairEditing,
                alertMessage: $alertMessage,
                alertShow: $alertShow
            )
            
            InfoCard(
                icon: "gauge",
                title: NSLocalizedString("Mileage", comment: "InfoCard"),
                value: "\(repair.repairMileage)",
                color: .primary,
                inputType: .value($mileage),
                isEditing: $isRepairEditing,
                alertMessage: $alertMessage,
                alertShow: $alertShow)
            
            InfoCard(
                icon: "tag.fill",
                title: NSLocalizedString("Category", comment: "InfoCard"),
                value: "\(NSLocalizedString(repair.repairCategory, comment: "InfoCard"))",
                color: .primary,
                inputType: .picker($category),
                isEditing: $isRepairEditing,
                alertMessage: $alertMessage,
                alertShow: $alertShow)
        
            if isRepairEditing || !(repair.notes?.isEmpty ?? true) {
                InfoCard(
                    icon: "text.alignleft",
                    title: NSLocalizedString("Description", comment: "InfoCard"),
                    value: repair.notes ?? "",
                    color: .primary,
                    inputType: .text($notes),
                    isEditing: $isRepairEditing,
                    alertMessage: $alertMessage,
                    alertShow: $alertShow)
            }
        }
        .alert(isPresented: $alertShow) {
            Alert(title: Text(NSLocalizedString("Invalid Input", comment: "")), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}


//#Preview {
//    let context = CoreDataStack.shared.context
//    let repair = Repair(context: context)
//    repair.partReplaced = "Brake pads"
//    repair.repairDate = Date()
//    repair.amount = 100000
//    repair.repairMileage = 10000
//    repair.repairCategory = "Service"
//    repair.notes = "Replaced pads"
//    
//    return InfoCardView(
//        isRepairEditing: .constant(true),
//        cost: .constant(Int(repair.amount)),
//        mileage: .constant(Int(repair.repairMileage)),
//        category: .constant(.service),
//        notes: .constant(repair.notes ?? ""),
//        repair: repair)
//}

// ---------------------------------------------------------------

enum InputType {
    case text(Binding<String>)
    case value(Binding<Int?>)
    case picker(Binding<RepairCategory>)
}

struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    let inputType: InputType
    
    @Binding var isEditing: Bool
    @Binding var alertMessage: String
    @Binding var alertShow: Bool
    
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
                    case .text(let text):
                        TextField("Enter description", text: text)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                    case .value(let value):
                        TextField("Enter value", value: value, formatter: NumberFormatter())
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                            .keyboardType(.numberPad)
                            .onChange(of: value.wrappedValue) {newValue in
                                if let newValue = newValue, newValue <= 0 {
                                    alertMessage = NSLocalizedString("Ops... Value must be greater than zero.", comment: "InfoCardEND")
                                    alertShow = true
                                }
                            }
                    case .picker(let picker):
                        Picker(NSLocalizedString("Categories", comment: ""), selection: picker) {
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
                    Text(value)
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
