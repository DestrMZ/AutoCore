//
//  CarModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 15.06.2025.
//

import Foundation


struct CarModel: Identifiable, Equatable {
    let id: UUID
    let nameModel: String
    let year: Int16
    let color: String?
    let engineType: String
    let transmissionType: String
    let existingVinNumbers: [String]?
    let mileage: Int32
    let photoCar: Data
    let vinNumbers: String
    let repairs: [RepairModel]?
    let insurance: [InsuranceModel]?
    let stateNumber: String?
}
