//
//  MockInsuranceRepository.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 17.07.2025.
//

import Foundation

final class MockInsuranceRepository: InsuranceRepositoryProtocol {
    
    var mockInsurances: [InsuranceModel] = []
    var shouldFail: Bool = false
    
    func createInsurance(insuranceModel: InsuranceModel, for carID: UUID) throws -> InsuranceModel {
        if shouldFail {
            throw RepositoryError.createFailed
        }
        mockInsurances.append(insuranceModel)
        return insuranceModel
    }
    
    func fetchInsurances(for carID: UUID) throws -> [InsuranceModel] {
        if shouldFail {
            throw RepositoryError.fetchFailed
        }
        return mockInsurances
    }
    
    func updateInsurance(insuranceModel: InsuranceModel, for carID: UUID) throws {
        if shouldFail {
            throw RepositoryError.updateFailed
        }
        guard let index = mockInsurances.firstIndex(where: { $0.id == insuranceModel.id }) else {
            throw RepositoryError.insuranceNotFound
        }
        mockInsurances[index] = insuranceModel
    }
    
    func deleteInsurance(insuranceModel: InsuranceModel) throws {
        if shouldFail {
            throw RepositoryError.deleteFailed
        }
        guard let index = mockInsurances.firstIndex(where: { $0.id == insuranceModel.id }) else {
            throw RepositoryError.insuranceNotFound
        }
        mockInsurances.remove(at: index)
    }
}
