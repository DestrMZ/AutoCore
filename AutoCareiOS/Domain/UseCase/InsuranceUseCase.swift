//
//  InsuranceUseCase.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 23.06.2025.
//

import Foundation


class InsuranceUseCase: InsuranceUseCaseProtocol {
    
    private let insuranceRepository: InsuranceRepositoryProtocol
    
    init(insuranceRepository: InsuranceRepositoryProtocol) {
        self.insuranceRepository = insuranceRepository
    }
    
    func createInsurance(for carModel: CarModel, with insuranceModel: InsuranceModel) throws {
        try validateInsurance(insuranceModel, for: carModel)
        
        do {
            try insuranceRepository.createInsurance(insuranceModel: insuranceModel, for: carModel.id)
            debugPrint("[InsuranceUseCase] \(insuranceModel.nameCompany) successful created!")
        } catch {
            throw InsuranceError.saveFailed
        }
    }
    
    func fetchAllInsurances(for carModel: CarModel) throws -> [InsuranceModel] {
        do {
            return try insuranceRepository.fetchInsurances(for: carModel.id)
        } catch {
            throw InsuranceError.fetchFailed
        }
    }
    
    func updateInsurance(for carModel: CarModel, with insuranceModel: InsuranceModel) throws {
        try validateInsurance(insuranceModel, for: carModel)
        
        do {
            try insuranceRepository.updateInsurance(insuranceModel: insuranceModel, for: carModel.id)
            debugPrint("[InsuranceUseCase] \(insuranceModel.nameCompany) successful updated!")
        } catch {
            throw InsuranceError.updateFailed
        }
    }
    
    func deleteInsurance(insuranceModel: InsuranceModel) throws {
        do {
            try insuranceRepository.deleteInsurance(insuranceModel: insuranceModel)
            debugPrint( "[InsuranceUseCase] \(insuranceModel.nameCompany) successful deleted!")
        } catch {
            throw InsuranceError.deleteFailed
        }
    }
    
    func validateInsurance(_ insuranceModel: InsuranceModel, for carModel: CarModel?) throws {
        guard carModel != nil else {
            throw InsuranceError.carNotAttached
        }

        if insuranceModel.nameCompany.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw InsuranceError.missingCompanyName
        }

        if insuranceModel.type.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw InsuranceError.missingInsuranceType
        }

        if insuranceModel.price <= 0 {
            throw InsuranceError.invalidPrice
        }

        if insuranceModel.startDate >= insuranceModel.endDate {
            throw InsuranceError.startDateAfterEndDate
        }

        if insuranceModel.endDate < Date() {
            throw InsuranceError.endDateInPast
        }

        if let notificationDate = insuranceModel.notificationDate {
            if notificationDate < Date() {
                throw InsuranceError.notificationSetInPast
            }
        }
    }
}


protocol InsuranceUseCaseProtocol {
    func createInsurance(for carModel: CarModel, with insuranceModel: InsuranceModel) throws
    
    func updateInsurance(for carModel: CarModel, with insuranceModel: InsuranceModel) throws
    
    func fetchAllInsurances(for carModel: CarModel) throws -> [InsuranceModel]
    
    func deleteInsurance(insuranceModel: InsuranceModel) throws
    
    func validateInsurance(_ insuranceModel: InsuranceModel, for carModel: CarModel?) throws
}
