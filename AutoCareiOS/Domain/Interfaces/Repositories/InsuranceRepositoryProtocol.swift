//
//  InsuranceRepositoryProtocol.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 29.06.2025.
//

import Foundation


protocol InsuranceRepositoryProtocol {
    func createInsurance(insuranceModel: InsuranceModel, for carID: UUID) throws -> InsuranceModel
    
    func fetchInsurances(for carID: UUID) throws -> [InsuranceModel]
    
    func updateInsurance(insuranceModel: InsuranceModel, for carID: UUID) throws
    
    func deleteInsurance(insuranceModel: InsuranceModel) throws
}
