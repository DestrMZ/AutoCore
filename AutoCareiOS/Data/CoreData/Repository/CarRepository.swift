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
    
    func createCar(_ carModel: CarModel) -> Result<CarModel, CarRepositoryError> {
        
        let car = Car(context: context)
        CarMapper.mapToCoreData(carModel: carModel, entity: car)
        
        do {
            try context.save()
            let carModel = CarMapper.mapToModel(entity: car)
            return .success(carModel)
        } catch {
            debugPrint("[CarRepository] Failed to create car: \(error.localizedDescription)")
            return .failure(.creationFailed)
        }
    }
    
    func getAllCars() -> Result<[CarModel], CarRepositoryError> {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        
        do {
            let cars = try context.fetch(fetchRequest)
            let result = cars.map { CarMapper.mapToModel(entity: $0) }
            return .success(result)
        } catch {
            debugPrint("[CarRepository] Failed to fetch cars: \(error.localizedDescription)")
            return .failure(.carNotFound)
        }
    }
    
    func updateCar(_ car: CarModel) -> Result<CarModel, CarRepositoryError> {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", car.id as CVarArg)
        do {
            guard let entity = try context.fetch(fetchRequest).first else {
                return .failure(.updateFailed)
            }
            
            CarMapper.mapToCoreData(carModel: car, entity: entity)
            
            try context.save()
            
            let updatedCar = CarMapper.mapToModel(entity: entity)
            return .success(updatedCar)
        } catch {
            debugPrint("[CarRepository] Failed to update car: \(error.localizedDescription)")
            return .failure(.updateFailed)
        }
    }
    
    func updateMileage(for car: CarModel, newMileage: Int32) -> Result<Void, CarRepositoryError> {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", car.id as CVarArg)
        do {
            guard let entity = try context.fetch(fetchRequest).first else {
                return .failure(.carNotFound)
            }
            entity.mileage = newMileage
            try context.save()
            return .success(())
        } catch {
            debugPrint("[CarRepository] Failed to update mileage: \(error.localizedDescription)")
            return .failure(.updateMileageFailed)
        }
    }
    
    func deleteCar(_ car: CarModel) -> Result<Void, CarRepositoryError> {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", car.id as CVarArg)
        do {
            guard let entity = try context.fetch(fetchRequest).first else {
                return .failure(.deleteFailed)
            }
            context.delete(entity)
            try context.save()
            return .success(())
        } catch {
            debugPrint("[CarRepository] Failed to delete car: \(error.localizedDescription)")
            return .failure(.deleteFailed)
        }
    }
}


protocol CarRepositoryProtocol {
    func createCar(_ carModel: CarModel) -> Result<CarModel, CarRepositoryError>

    func getAllCars() -> Result<[CarModel], CarRepositoryError>

    func updateCar(_ car: CarModel) -> Result<CarModel, CarRepositoryError>

    func updateMileage(for car: CarModel, newMileage: Int32) -> Result<Void, CarRepositoryError>

    func deleteCar(_ car: CarModel) -> Result<Void, CarRepositoryError>
}
