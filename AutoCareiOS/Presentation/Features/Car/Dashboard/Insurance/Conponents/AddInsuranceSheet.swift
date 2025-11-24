//
//  AddInsuranceSheet.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 13.06.2025.
//

import SwiftUI

struct AddInsuranceSheet: View {
    
    @ObservedObject var vm: InsuranceViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var type = ""
    @State private var nameCompany = ""
    @State private var startDate = Date.now
    @State private var endDate = Date()
    @State private var price: Int32 = 0
    @State private var notes = ""
    @State private var notificationDate: Date?
    @State private var isNotificationEnabled = false
    
    var car: CarModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Insurance info")) {
                    TextField("Company name", text: $nameCompany)
                    TextField("Insurance type", text: $type)
                    
                    HStack {
                        Text("Price")
                        Spacer()
                        TextField("0", value: $price, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(header: Text("Dates")) {
                    DatePicker("Start date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End date", selection: $endDate, displayedComponents: .date)
                }
                
                Section("Notification") {
                    Toggle("Enable notification", isOn: Binding(
                        get: { notificationDate != nil },
                        set: { isOn in
                            if isOn && notificationDate == nil {
                                notificationDate = endDate
                            } else if !isOn {
                                notificationDate = nil
                            }
                        }
                    ))
                    
                    if notificationDate != nil {
                        DatePicker("Notification Date", selection: Binding(
                            get: { notificationDate ?? Date() },
                            set: { notificationDate = $0 }
                        ), displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section(header: Text("Additional")) {
                    TextField("Notes", text: $notes)
                }
            }
            .navigationTitle("Add insurance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let insurance = InsuranceModel(
                            id: vm.selectedInsurance?.id ?? UUID(),
                            type: type,
                            nameCompany: nameCompany,
                            startDate: startDate,
                            endDate: endDate,
                            price: price,
                            notes: notes,
                            notificationDate: notificationDate,
                            isActive: true
                        )
                        
                        if vm.selectedInsurance != nil {
                            vm.updateInsurance(for: car, insurance: insurance)
                        } else {
                            vm.addInsurance(for: car, insurance: insurance)
                        }
                        
                        if !vm.isShowAlert {
                            dismiss()
                            vm.resetFields()
                        }
                    }
                    .disabled(type.isEmpty || nameCompany.isEmpty)
                }
            }
            .alert(isPresented: $vm.isShowAlert) {
                Alert(
                    title: Text(NSLocalizedString("😳 Wow...", comment: "")),
                    message: Text(vm.alertMessage))
            }
            .task {
                if let existing = vm.selectedInsurance {
                    type = existing.type
                    nameCompany = existing.nameCompany
                    startDate = existing.startDate
                    endDate = existing.endDate
                    price = existing.price
                    notes = existing.notes ?? ""
                    notificationDate = existing.notificationDate
                    isNotificationEnabled = existing.notificationDate != nil
                }
            }
        }
    }
}


#Preview("Add New Insurance") {
    let mockCar = CarModel(id: UUID(), nameModel: "Tesla Model 3", year: 2023, engineType: "Gasoline", transmissionType: "Manual", mileage: 12000, vinNumbers: "5YJ3E1EA7JF123456")
    
    let mockStore = InsuranceStore(insuranceUseCase: InsuranceUseCase(insuranceRepository: MockInsuranceRepository()))
    
    // Мок ViewModel
    let mockVM = InsuranceViewModel(insuranceStore: mockStore)
    
    return AddInsuranceSheet(vm: mockVM, car: mockCar)
}

#Preview("Edit Existing Insurance") {
    let mockCar = CarModel(id: UUID(), nameModel: "Tesla Model 3", year: 2023, engineType: "Gasoline", transmissionType: "Manual", mileage: 12000, vinNumbers: "5YJ3E1EA7JF123456")
    
    let mockStore = InsuranceStore(insuranceUseCase: InsuranceUseCase(insuranceRepository: MockInsuranceRepository()))
    let mockVM = InsuranceViewModel(insuranceStore: mockStore)
    
    let existingInsurance = InsuranceModel(
        id: UUID(),
        type: "КАСКО",
        nameCompany: "Ингосстрах",
        startDate: Date().addingTimeInterval(-30*86400),
        endDate: Date().addingTimeInterval(335*86400),
        price: 125000,
        notes: "Полное покрытие + стекло",
        notificationDate: Date().addingTimeInterval(300*86400),
        isActive: true
    )
    
    mockVM.selectInsurance(existingInsurance)
    
    return AddInsuranceSheet(vm: mockVM, car: mockCar)
}


