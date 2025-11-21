//
//  InsuranceStore.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 16.11.2025.
//

import Foundation


@MainActor
final class InsuranceStore: ObservableObject {

    private let insuranceUseCase: InsuranceUseCaseProtocol
    private var notificationService: NotificationServiceProtocol = NotificationService()

    @Published private(set) var insurances: [InsuranceModel] = []
    @Published private(set) var selectedInsurance: InsuranceModel? = nil

    init(insuranceUseCase: InsuranceUseCaseProtocol, notificationService: NotificationServiceProtocol = NotificationService()) {
        self.insuranceUseCase = insuranceUseCase
        self.notificationService = notificationService
    }
    
    deinit {
        print("InsuranceStore - is deinitialized")
    }

    func loadInsurances(for car: CarModel) throws {
        let fetched = try insuranceUseCase.fetchAllInsurances(for: car)
        self.insurances = fetched
    }

    func addInsurance(for car: CarModel, insuranceModel: InsuranceModel) throws {
        let created = try insuranceUseCase.createInsurance(for: car, with: insuranceModel)
        self.insurances.append(created)
        
        if let date = created.notificationDate {
            notificationService.scheduleNotification(
                id: created.id.uuidString,
                title: "Your insurance is expiring soon",
                body: "\(created.type) expires on \(created.endDate). Don’t forget to renew it.",
                date: date)
        }
    }

    func updateInsurance(for car: CarModel, insuranceModel: InsuranceModel) throws {
        guard let oldModel = insurances.first(where: { $0.id == insuranceModel.id }) else {
            throw InsuranceError.insuranceNotFound}
        
        try insuranceUseCase.updateInsurance(for: car, with: insuranceModel)

        if let index = insurances.firstIndex(where: { $0.id == insuranceModel.id }) {
            insurances[index] = insuranceModel
        }
        
        handleInsuranceNotificationUpdate(old: oldModel, new: insuranceModel)
    }

    func selectInsurance(_ insurance: InsuranceModel?) {
        self.selectedInsurance = insurance
    }

    func deleteInsurance(_ insuranceModel: InsuranceModel) throws {
        try insuranceUseCase.deleteInsurance(insuranceModel: insuranceModel)

        if let index = insurances.firstIndex(of: insuranceModel) {
            insurances.remove(at: index)
        }

        notificationService.removeNotification(id: insuranceModel.id.uuidString)

        if selectedInsurance == insuranceModel {
            selectedInsurance = nil
        }
    }
    
    private func handleInsuranceNotificationUpdate(old: InsuranceModel, new: InsuranceModel) {
        let id = new.id.uuidString
        let oldDate = old.notificationDate
        let newDate = new.notificationDate
        
        if oldDate == nil, newDate == nil {
            debugPrint("Notification unchanged (nil → nil) for \(id)")
            return
        }
        
        if oldDate != nil, newDate == nil {
            notificationService.removeNotification(id: id)
            debugPrint("Notification was removed for \(id)")
            return
        }
        
        if oldDate == nil, let newDate {
            notificationService.scheduleNotification(
                id: id,
                title: "Insurance reminder",
                body: "Your \(new.type) insurance expires on \(new.endDate.formatted(date: .long, time: .omitted)).",
                date: newDate
            )
            debugPrint("Added new notification for \(id)")
            return
        }
        
        if let oldDate, let newDate, oldDate != newDate {
            notificationService.removeNotification(id: id)
            notificationService.scheduleNotification(
                id: id,
                title: "Insurance reminder",
                body: "Your \(new.type) insurance expires on \(new.endDate.formatted(date: .long, time: .omitted)).",
                date: newDate
            )
            debugPrint("Updated notification for \(id)")
            return
        }

        debugPrint("Notification unchanged for \(id)")
    }
}
