//
//  MockModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 20.11.2025.
//

import Foundation
@testable import AutoCareiOS


extension CarModel {
    static func mock(id: UUID = UUID(), mileage: Int32 = 1000) -> CarModel {
        CarModel(
            id: id,
            nameModel: "Model S",
            year: 2024,
            color: "Red",
            engineType: EngineTypeEnum.electric.rawValue,
            transmissionType: TransmissionTypeEnum.automatic.rawValue,
            mileage: mileage,
            photoCar: Data(),
            vinNumbers: "VIN\(id)",
            repairs: [],
            insurance: [],
            stateNumber: "A000AA"
        )
    }
}

extension InsuranceModel {
    static func mock(id: UUID = UUID()) -> InsuranceModel {
        InsuranceModel(
            id: id,
            type: "OSAGO",
            nameCompany: "MockCo",
            startDate: Date(),
            endDate: Date().addingTimeInterval(3600),
            price: 10,
            notes: nil,
            notificationDate: nil,
            isActive: true
        )
    }
}

extension RepairModel {
    static func mock(id: UUID = UUID(), litres: Double? = nil) -> RepairModel {
        RepairModel(
            id: id,
            amount: 100,
            litresFuel: litres,
            notes: nil,
            partReplaced: "Filter",
            parts: [:],
            photoRepairs: nil,
            repairCategory: "service",
            repairDate: Date(),
            repairMileage: 1000
        )
    }
}
