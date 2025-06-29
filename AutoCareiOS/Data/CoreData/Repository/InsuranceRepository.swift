//
//  InsuranceRepository.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 15.06.2025.
//

import Foundation
import CoreData


class InsuranceRepository: InsuranceRepositoryProtocol {
    
    private let context = CoreDataStack.shared.context
    
    func createInsurance(insuranceModel: InsuranceModel, for carID: UUID) throws -> InsuranceModel {
        
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", carID as CVarArg)
        
        do {
            guard let entity = try context.fetch(fetchRequest).first else {
                throw RepositoryError.carNotFound
            }
            
            let insurance = Insurance(context: context)
            
            InsuranceMapper.mapToCoreData(
                insuranceModel: insuranceModel,
                entity: insurance,
                for: entity)
            
            try context.save()
            return InsuranceMapper.mapToModel(entity: insurance)
        } catch {
            debugPrint("[InsuranceRepository] Failed to create insurance – car with ID \(carID) not found: \(error.localizedDescription).")
            throw RepositoryError.createFailed
        }
    }
    
    func fetchInsurances(for carID: UUID) throws -> [InsuranceModel] {
        let fetchRequest: NSFetchRequest<Insurance> = Insurance.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "car.id == %@", carID as CVarArg)
        
        do {
            let insurances = try context.fetch(fetchRequest)
            return insurances.map { InsuranceMapper.mapToModel(entity: $0)}
        } catch {
            debugPrint("[InsuranceRepository] Failed to fetch insurances for car ID \(carID): \(error.localizedDescription).")
            throw RepositoryError.fetchFailed
        }
    }
    
    func updateInsurance(insuranceModel: InsuranceModel, for carID: UUID) throws {
        
        let fetchRequestInsurance: NSFetchRequest<Insurance> = Insurance.fetchRequest()
        fetchRequestInsurance.predicate = NSPredicate(format: "id == %@", insuranceModel.id as CVarArg)
        
        let fetchRequestCar: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequestCar.predicate = NSPredicate(format: "id == %@", carID as CVarArg)
        
        do {
            guard let entityInsurance = try context.fetch(fetchRequestInsurance).first else {
                throw RepositoryError.insuranceNotFound
            }
            
            guard let entityCar = try context.fetch(fetchRequestCar).first else {
                throw RepositoryError.carNotFound
            }
            
            InsuranceMapper.mapToCoreData(
                insuranceModel: insuranceModel,
                entity: entityInsurance,
                for: entityCar)
            
            try context.save()
        } catch {
            debugPrint("[InsuranceRepository] Failed to update insurance with ID \(insuranceModel.id): \(error.localizedDescription).")
            throw RepositoryError.updateFailed
        }
    }
    
    func deleteInsurance(insuranceModel: InsuranceModel) throws {
        let fetchRequest: NSFetchRequest<Insurance> = Insurance.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", insuranceModel.id as CVarArg)
        
        do {
            guard let entityInsurance = try context.fetch(fetchRequest).first else {
                throw RepositoryError.insuranceNotFound
            }

            context.delete(entityInsurance)
            try context.save()
        } catch {
            debugPrint("[InsuranceRepository] Failed to delete insurance with ID \(insuranceModel.id): \(error.localizedDescription).")
            throw RepositoryError.deleteFailed
        }
    }
}
