//
//  InsuranceViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 13.06.2025.
//

import Foundation
import SwiftUI


class InsuranceViewModel: ObservableObject {
    
    private var insuranceService = InsuranceService()
    
    @Published var type: String = ""
    @Published var nameCompany: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var price: Int32 = 0
    @Published var notes: String = ""
    @Published var notificationDate: Date? = nil
    @Published var isActive: Bool = true
    
    @Published var allInsurances: [Insurance] = []
    @Published var alertMessage: String? = nil
    @Published var alertShow: Bool = false
    
    @Published var selectedInsurance: Insurance? = nil
    
    func loadInsurances(car: Car?) {
        if let car = car {
            self.allInsurances = insuranceService.getAllInsurance(for: car)
        }
    }
    
    func createInsurance(for car: Car?) {
        guard let car = car else { return }
        
        alertShow = false
        
        let result = insuranceService.createInsurance(
            car: car,
            type: type,
            nameCompany: nameCompany,
            startDate: startDate,
            endDate: endDate,
            price: price,
            notes: notes,
            notificationDate: nil)
        
        switch result {
        case .success():
            loadInsurances(car: car)
            #warning("Проверить корректно ли меняются данные")
            if let insurance = allInsurances.last, let date = notificationDate {
                NotificationService.shared.scheduleNotification(
                    id: insurance.objectID.uriRepresentation().absoluteString,
                    title: "Insurance Ending Soon",
                    body: "Insurance for \(insurance.nameCompany) is ending soon!",
                    date: date)
            }
            
        case .failure(let error):
            alertMessage = error.localizedDescription
            alertShow = true
        }
    }
    
    func editingInsurance(for insurance: Insurance, type: String, nameCompany: String, startDate: Date, endDate: Date, price: Int32, notes: String, notificationDate: Date?) {
        alertShow = false
        
        let previousNotificationDate = insurance.notificationDate
        let notificationID = insurance.objectID.uriRepresentation().absoluteString
        
        let result = insuranceService.editingInsurance(
            for: insurance,
            type: type,
            nameCompany: nameCompany,
            startDate: startDate,
            endDate: endDate,
            price: price,
            notes: notes,
            notificationDate: notificationDate)
        
        switch result {
        case .success():
            if previousNotificationDate != nil && notificationDate == nil {
                NotificationService.shared.removeNotification(id: notificationID)
            }
            
            if let newDate = notificationDate, previousNotificationDate != newDate {
                NotificationService.shared.removeNotification(id: notificationID)
                NotificationService.shared.scheduleNotification(
                    id: notificationID,
                    title: "Insurance Ending Soon",
                    body: "Insurance for \(insurance.nameCompany) is ending soon!",
                    date: newDate)
            }
        case .failure(let error):
            alertMessage = error.localizedDescription
            alertShow = true
        }
    }
    
    func resetFields() {
        type = ""
        nameCompany = ""
        startDate = Date()
        endDate = Date()
        price = 0
        notes = ""
        notificationDate = nil
        isActive = true
    }
    
    func loadInsuranceInfo(from insurance: Insurance) {
        selectedInsurance = insurance
        type = insurance.type
        nameCompany = insurance.nameCompany
        startDate = insurance.startDate
        endDate = insurance.endDate
        price = insurance.price
        notes = insurance.notes ?? ""
        notificationDate = insurance.notificationDate
        isActive = insurance.isActive
    }
    
    func deleteInsurance(at offset: IndexSet) {
        offset.forEach { index in
            let insurance = self.allInsurances[index]
            
            insuranceService.deleteInsurance(at: insurance)
            NotificationService.shared.removeNotification(id: insurance.objectID.uriRepresentation().absoluteString)
            
            self.allInsurances.remove(at: index)
        }
        print("Insurance is deleted")
    }
}

