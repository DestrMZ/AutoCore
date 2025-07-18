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
    
    func createRepair(repairModel: RepairModel, for carID: UUID) throws -> RepairModel {
        
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", carID as CVarArg)
            
        do {
            guard let entity = try context.fetch(fetchRequest).first else {
                throw RepositoryError.carNotFound
            }
            
            let repair = Repair(context: context)
            
            RepairMapper.mapToEntity(
                repairModel: repairModel,
                entity: repair,
                entityCar: entity)
            
            try context.save()
            return RepairMapper.mapToModel(entity: repair)
        } catch {
            debugPrint("[RepairRepository] Failed to create repair for car ID \(carID): \(error.localizedDescription).")
            context.rollback()
            throw RepositoryError.createFailed
        }
    }
    
    func fetchAllRepairs(for carID: UUID) throws -> [RepairModel] {
        let fetchRequest: NSFetchRequest<Repair> = Repair.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "car.id == %@", carID as CVarArg)

        do {
            let repairs = try context.fetch(fetchRequest)
            return repairs.map { RepairMapper.mapToModel(entity: $0) }
        } catch {
            debugPrint("[RepairRepository] Failed to fetch repairs for car ID \(carID): \(error.localizedDescription).")
            throw RepositoryError.fetchFailed
        }
    }
    
    func updateRepair(repair: RepairModel, for carID: UUID) throws {
        let fetchRequestRepair: NSFetchRequest<Repair> = Repair.fetchRequest()
        fetchRequestRepair.predicate = NSPredicate(format: "id == %@", repair.id as CVarArg)
        
        let fetchRequestCar: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequestCar.predicate = NSPredicate(format: "id == %@", carID as CVarArg)
        
        do {
            guard let entityRepair = try context.fetch(fetchRequestRepair).first else {
                throw RepositoryError.repairNotFound
            }
            
            guard let entityCar = try context.fetch(fetchRequestCar).first else {
                throw RepositoryError.carNotFound
            }
            
            RepairMapper.mapToEntity(
                repairModel: repair,
                entity: entityRepair,
                entityCar: entityCar)
            
            try context.save()
        } catch {
            debugPrint("[RepairRepository] Failed to update repair with ID \(repair.id): \(error.localizedDescription).")
            context.rollback()
            throw RepositoryError.updateFailed
        }
    }
    
    func deleteRepair(repair: RepairModel) throws {
        let fetchRequest: NSFetchRequest<Repair> = Repair.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", repair.id as CVarArg)
        
        do {
            guard let entityRepair = try context.fetch(fetchRequest).first else {
                throw RepositoryError.repairNotFound
            }
                
            context.delete(entityRepair)
            try context.save()
        } catch {
            debugPrint("[RepairRepository] Failed to delete repair with ID \(repair.id): \(error.localizedDescription).")
            context.rollback()
            throw RepositoryError.deleteFailed
        }
    }
}
