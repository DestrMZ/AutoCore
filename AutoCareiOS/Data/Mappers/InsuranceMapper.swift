//
//  InsuranceMapper.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 15.06.2025.
//

import Foundation


struct InsuranceMapper {
    // Convert CoreData Insurance entity to Domain InsuranceModel
    static func mapToModel(entity: Insurance) -> InsuranceModel {
        return InsuranceModel(
            id: entity.id,
            type: entity.type,
            nameCompany: entity.nameCompany,
            startDate: entity.startDate,
            endDate: entity.endDate,
            price: entity.price,
            notes: entity.notes,
            notificationDate: entity.notificationDate,
            isActive: entity.isActive
        )
    }
    // Convert Domain InsuranceModel to CoreData Insurance entity
    static func mapToCoreData(insuranceModel: InsuranceModel, entity: Insurance, for entityCar: Car) {
        entity.id = insuranceModel.id
        entity.type = insuranceModel.type
        entity.nameCompany = insuranceModel.nameCompany
        entity.startDate = insuranceModel.startDate
        entity.endDate = insuranceModel.endDate
        entity.price = insuranceModel.price
        entity.notes = insuranceModel.notes
        entity.notificationDate = insuranceModel.notificationDate
        entity.isActive = insuranceModel.isActive
        entity.car = entityCar
    }
}
