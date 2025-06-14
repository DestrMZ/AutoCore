//
//  AddInsuranceSheet.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 13.06.2025.
//

import SwiftUI

struct AddInsuranceSheet: View {
    @ObservedObject var insuranceViewModel: InsuranceViewModel
    @Environment(\.dismiss) var dismiss

    @State var isPresented: Bool = false
    
    var car: Car?
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Insurance info")) {
                    TextField("Company name", text: $insuranceViewModel.nameCompany)
                    TextField("Insurance type", text: $insuranceViewModel.type)
                    
                    HStack {
                        Text("Price")
                        Spacer()
                        TextField("0", value: $insuranceViewModel.price, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(header: Text("Dates")) {
                    DatePicker("Start date", selection: $insuranceViewModel.startDate, displayedComponents: .date)
                    DatePicker("End date", selection: $insuranceViewModel.endDate, displayedComponents: .date)
                }
                
                Section(header: Text("Notification")) {
                    Toggle("Enable notification", isOn: Binding(
                        get: { insuranceViewModel.notificationDate != nil },
                        set: { isOn in
                            insuranceViewModel.notificationDate = isOn ? Date() : nil
                        }
                    ))
                    
                    if insuranceViewModel.notificationDate != nil {
                        DatePicker("Notification Date", selection: Binding(
                            get: { insuranceViewModel.notificationDate ?? Date() },
                            set: { newDate in
                                insuranceViewModel.notificationDate = newDate
                            }
                        ), displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section(header: Text("Additional")) {
                    TextField("Notes", text: $insuranceViewModel.notes)
                }
            }
            .navigationTitle("Add insurance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                        insuranceViewModel.resetFields()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let existing = insuranceViewModel.selectedInsurance {
                            insuranceViewModel.editingInsurance(
                                for: existing,
                                type: insuranceViewModel.type,
                                nameCompany: insuranceViewModel.nameCompany,
                                startDate: insuranceViewModel.startDate,
                                endDate: insuranceViewModel.endDate,
                                price: insuranceViewModel.price,
                                notes: insuranceViewModel.notes,
                                notificationDate: insuranceViewModel.notificationDate)
                        } else {
                            insuranceViewModel.createInsurance(for: car)
                        }
                        if !insuranceViewModel.alertShow {
                            dismiss()
                            insuranceViewModel.resetFields()
                            insuranceViewModel.selectedInsurance = nil
                        }
                    }
                }
            }
            .alert(isPresented: $insuranceViewModel.alertShow) {
                Alert(
                    title: Text(NSLocalizedString("😳 Wow...", comment: "")),
                    message: Text(insuranceViewModel.alertMessage ?? ""))
            }
        }
    }
}


#Preview {
    let car = Car(context: CoreDataStack.shared.context)
    AddInsuranceSheet(insuranceViewModel: InsuranceViewModel(), car: car)
}
