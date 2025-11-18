//
//  CarModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 15.06.2025.
//

import Foundation


struct CarModel: Identifiable, Equatable {
    let id: UUID
    var nameModel: String
    var year: Int16
    var color: String?
    var engineType: String
    var transmissionType: String
    var mileage: Int32
    var photoCar: Data?
    var vinNumbers: String
    var repairs: [RepairModel]?
    var insurance: [InsuranceModel]?
    var stateNumber: String?
}
