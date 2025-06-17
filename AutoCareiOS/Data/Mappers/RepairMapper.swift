//
//  RepairMapper.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 15.06.2025.
//

import Foundation


struct RepairMapper {
    // Convert CoreData Repair entity to Domain RepairModel
    static func mapToModel(entity: Repair) -> RepairModel {
        return RepairModel(
            id: entity.id,
            amount: entity.amount,
            litresFuel: entity.litresFuel?.doubleValue,
            notes: entity.notes,
            partReplaced: entity.partReplaced,
            parts: entity.parts ?? [:],
            photoRepairs: entity.photoRepair,
            repairCategory: entity.repairCategory,
            repairDate: entity.repairDate,
            repairMileage: entity.repairMileage)
    }
    // Convert Domain RepairModel to CoreData Repair entity
    static func mapToEntity(repairModel: RepairModel, entity: Repair, entityCar: Car) {
        entity.id = repairModel.id
        entity.amount = repairModel.amount
        entity.litresFuel = repairModel.litresFuel.map { NSNumber(value: $0) }
        entity.notes = repairModel.notes
        entity.partReplaced = repairModel.partReplaced
        entity.parts = repairModel.parts
        entity.photoRepair = repairModel.photoRepairs
        entity.repairCategory = repairModel.repairCategory
        entity.repairDate = repairModel.repairDate
        entity.repairMileage = repairModel.repairMileage
        entity.car = entityCar
    }
}
