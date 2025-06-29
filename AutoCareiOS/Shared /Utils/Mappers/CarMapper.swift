//
//  CarMapper.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 15.06.2025.
//

import Foundation


struct CarMapper {
    // Convert CoreData Car entity to Domain CarModel
    static func mapToModel(entity: Car) -> CarModel {
        let repairs = (entity.repairs as? Set<Repair>)?.map(RepairMapper.mapToModel) ?? []
        let insurances = (entity.insurance as? Set<Insurance>)?.map(InsuranceMapper.mapToModel) ?? []
        
        return CarModel(
            id: entity.id,
            nameModel: entity.nameModel,
            year: entity.year,
            color: entity.color,
            engineType: entity.engineType,
            transmissionType: entity.transmissionType,
            mileage: entity.mileage,
            photoCar: entity.photoCar,
            vinNumbers: entity.vinNumber,
            repairs: repairs,
            insurance: insurances,
            stateNumber: entity.stateNumber)
    }
    // Convert Domain CarModel to CoreData Car entity
    static func mapToCoreData(carModel: CarModel, entity: Car) {
        entity.id = carModel.id
        entity.nameModel = carModel.nameModel
        entity.year = carModel.year
        entity.color = carModel.color
        entity.engineType = carModel.engineType
        entity.transmissionType = carModel.transmissionType
        entity.mileage = carModel.mileage
        entity.photoCar = carModel.photoCar
        entity.vinNumber = carModel.vinNumbers
        entity.stateNumber = carModel.stateNumber
    }
}
