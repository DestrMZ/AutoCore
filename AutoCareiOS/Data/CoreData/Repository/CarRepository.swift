//
//  CarRepository.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 15.06.2025.
//

import Foundation
import CoreData


class CarRepository: CarRepositoryProtocol {
    
    private let context = CoreDataStack.shared.context
    
    func createCar(_ carModel: CarModel) throws -> CarModel {
        
        let car = Car(context: context)
        CarMapper.mapToCoreData(carModel: carModel, entity: car)
        
        do {
            try context.save()
            return CarMapper.mapToModel(entity: car)
        } catch {
            debugPrint("[CarRepository] Failed to save car: \(error.localizedDescription).")
            throw RepositoryError.createFailed
        }
    }
    
    func getCar(carID: UUID) throws -> CarModel {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", carID as CVarArg)
        
        do {
            guard let entity = try context.fetch(fetchRequest).first else {
                debugPrint("[CarRepository] Car with ID \(carID) not found.")
                throw RepositoryError.objectNotFound
            }
            return CarMapper.mapToModel(entity: entity)
        } catch {
            debugPrint("[CarRepository] Failed to fetch car with ID \(carID): \(error.localizedDescription).")
            throw RepositoryError.fetchFailed
        }
    }
    
    func getAllCars() throws -> [CarModel] {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        
        do {
            let cars = try context.fetch(fetchRequest)
            let carsModel = cars.map { CarMapper.mapToModel(entity: $0) }
            return carsModel
        } catch {
            debugPrint("[CarRepository] Failed to get all cars: \(error.localizedDescription).")
            throw RepositoryError.fetchFailed
        }
    }
    
    func updateCar(_ car: CarModel) throws -> CarModel {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", car.id as CVarArg)
        do {
            guard let entity = try context.fetch(fetchRequest).first else {
                throw RepositoryError.objectNotFound
            }
            
            CarMapper.mapToCoreData(carModel: car, entity: entity)
            
            try context.save()
            
            return CarMapper.mapToModel(entity: entity)
        } catch {
            debugPrint("[CarRepository] Failed to update car: \(error.localizedDescription).")
            throw RepositoryError.updateFailed
        }
    }
    
    func updateMileage(for car: CarModel, newMileage: Int32) throws {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", car.id as CVarArg)
        do {
            guard let entity = try context.fetch(fetchRequest).first else {
                throw RepositoryError.objectNotFound
            }
            entity.mileage = newMileage
            try context.save()
        } catch {
            debugPrint("[CarRepository] Failed to update mileage: \(error.localizedDescription).")
            throw RepositoryError.updateFailed
        }
    }
    
    func deleteCar(_ car: CarModel) throws {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", car.id as CVarArg)
        do {
            guard let entity = try context.fetch(fetchRequest).first else {
                throw RepositoryError.objectNotFound
            }
            context.delete(entity)
            try context.save()
        } catch {
            debugPrint("[CarRepository] Failed to delete car: \(error.localizedDescription)")
            throw RepositoryError.deleteFailed
        }
    }
}


protocol CarRepositoryProtocol {
    func createCar(_ carModel: CarModel) throws -> CarModel

    func getAllCars() throws -> [CarModel]
    
    func getCar(carID: UUID) throws -> CarModel

    func updateCar(_ car: CarModel) throws -> CarModel

    func updateMileage(for car: CarModel, newMileage: Int32) throws

    func deleteCar(_ car: CarModel) throws
}
