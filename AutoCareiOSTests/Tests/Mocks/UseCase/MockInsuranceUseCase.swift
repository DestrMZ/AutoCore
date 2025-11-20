//
//  MockInsuranceUseCase.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 20.11.2025.
//

import Foundation
@testable import AutoCareiOS


final class InsuranceUseCaseMock: InsuranceUseCaseProtocol {
    var insurances: [InsuranceModel]
    var error: Error?

    init(insurances: [InsuranceModel]) {
        self.insurances = insurances
    }

    func createInsurance(for carModel: CarModel, with insuranceModel: InsuranceModel) throws -> InsuranceModel {
        if let error { throw error }
        insurances.append(insuranceModel)
        return insuranceModel
    }

    func updateInsurance(for carModel: CarModel, with insuranceModel: InsuranceModel) throws {
        if let error { throw error }
        guard let index = insurances.firstIndex(where: { $0.id == insuranceModel.id }) else { return }
        insurances[index] = insuranceModel
    }

    func fetchAllInsurances(for carModel: CarModel) throws -> [InsuranceModel] {
        if let error { throw error }
        return insurances
    }

    func deleteInsurance(insuranceModel: InsuranceModel) throws {
        if let error { throw error }
        insurances.removeAll(where: { $0.id == insuranceModel.id })
    }

    func validateInsurance(_ insuranceModel: InsuranceModel, for carModel: CarModel) throws { }
}
