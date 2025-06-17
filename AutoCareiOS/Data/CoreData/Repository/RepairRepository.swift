//
//  RepairRepository.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 15.06.2025.
//

import Foundation
import CoreData


class RepairRepository: RepairRepositoryProtocol {
    
    private let context = CoreDataStack.shared.context
    
    func createRepair(repairModel: RepairModel, for carID: UUID) -> Result<Void, RepairRepositoryError> {
        
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", carID as CVarArg)
            
        do {
            guard let entity = try context.fetch(fetchRequest).first else {
                return .failure(.carNotFound)
            }
            
            let repair = Repair(context: context)
            
            RepairMapper.mapToEntity(
                repairModel: repairModel,
                entity: repair,
                entityCar: entity)
            
            try context.save()
            return .success(())
        } catch {
            debugPrint("RepairRepository: Failed to create repair for car ID \(carID): \(error.localizedDescription)")
            return .failure(.creationFailed)
        }
    }
    
    func getAllRepairs(for carID: UUID) -> Result<[RepairModel], RepairRepositoryError> {
        let fetchRequest: NSFetchRequest<Repair> = Repair.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "car.id == %@", carID as CVarArg)

        do {
            let repairs = try context.fetch(fetchRequest)
            let result = repairs.map { RepairMapper.mapToModel(entity: $0) }
            return .success(result)
        } catch {
            debugPrint("RepairRepository: Failed to fetch repairs for car ID \(carID): \(error.localizedDescription)")
            return .failure(.fetchFailed)
        }
    }
    
    func updateRepair(repair: RepairModel, for carID: UUID) -> Result<Void, RepairRepositoryError> {
        let fetchRequestRepair: NSFetchRequest<Repair> = Repair.fetchRequest()
        fetchRequestRepair.predicate = NSPredicate(format: "id == %@", repair.id as CVarArg)
        
        let fetchRequestCar: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequestCar.predicate = NSPredicate(format: "id == %@", carID as CVarArg)
        
        do {
            guard let entityRepair = try context.fetch(fetchRequestRepair).first else {
                debugPrint("RepairRepository: Failed to update – repair with ID \(repair.id) not found.")
                return .failure(.repairNotFound)
            }
            
            guard let entityCar = try context.fetch(fetchRequestCar).first else {
                debugPrint("RepairRepository: Failed to update – car with ID \(carID) not found.")
                return .failure(.carNotFound)
            }
            
            RepairMapper.mapToEntity(
                repairModel: repair,
                entity: entityRepair,
                entityCar: entityCar)
            
            try context.save()
            return .success(())
        } catch {
            debugPrint("RepairRepository: Failed to update repair with ID \(repair.id): \(error.localizedDescription)")
            return .failure(.updateFailed)
        }
    }
    
    func deleteRepair(repair: RepairModel) -> Result<Void, RepairRepositoryError> {
        let fetchRequest: NSFetchRequest<Repair> = Repair.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", repair.id as CVarArg)
        
        do {
            if let entityRepair = try context.fetch(fetchRequest).first {
                context.delete(entityRepair)
                try context.save()
                return .success(())
            }
            debugPrint("RepairRepository: Failed to delete – repair with ID \(repair.id) not found.")
            return .failure(.repairNotFound)
        } catch {
            debugPrint("RepairRepository: Failed to delete repair with ID \(repair.id): \(error.localizedDescription)")
            return .failure(.deleteFailed)
        }
    }
}


protocol RepairRepositoryProtocol {
    func createRepair(repairModel: RepairModel, for carID: UUID) -> Result<Void, RepairRepositoryError>
    
    func getAllRepairs(for carID: UUID) -> Result<[RepairModel], RepairRepositoryError>
    
    func updateRepair(repair: RepairModel, for carID: UUID) -> Result<Void, RepairRepositoryError>
    
    func deleteRepair(repair: RepairModel) -> Result<Void, RepairRepositoryError>
}
