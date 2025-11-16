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

    @Published private(set) var insurances: [InsuranceModel] = []
    @Published private(set) var selectedInsurance: InsuranceModel? = nil

    init(insuranceUseCase: InsuranceUseCaseProtocol) {
        self.insuranceUseCase = insuranceUseCase
    }

    func loadInsurances(for car: CarModel) throws {
        let fetched = try insuranceUseCase.fetchAllInsurances(for: car)
        self.insurances = fetched
    }

    func addInsurance(for car: CarModel, insuranceModel: InsuranceModel) throws {
        let created = try insuranceUseCase.createInsurance(for: car, with: insuranceModel)
        self.insurances.append(created)
    }

    func updateInsurance(for car: CarModel, insuranceModel: InsuranceModel) throws {
        try insuranceUseCase.updateInsurance(for: car, with: insuranceModel)

        if let index = insurances.firstIndex(where: { $0.id == insuranceModel.id }) {
            insurances[index] = insuranceModel
        }
    }

    func selectInsurance(_ insurance: InsuranceModel?) {
        self.selectedInsurance = insurance
    }

    func deleteInsurance(_ insuranceModel: InsuranceModel) throws {
        try insuranceUseCase.deleteInsurance(insuranceModel: insuranceModel)

        if let index = insurances.firstIndex(of: insuranceModel) {
            insurances.remove(at: index)
        }

        NotificationService.shared.removeNotification(id: insuranceModel.id.uuidString)

        if selectedInsurance == insuranceModel {
            selectedInsurance = nil
        }
    }
}
