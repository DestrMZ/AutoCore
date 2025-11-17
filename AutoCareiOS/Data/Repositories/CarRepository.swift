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
        } catch let error as NSError {
            if error.domain == NSCocoaErrorDomain && (error.code == 133021 || error.code == 1550) {
                // NSManagedObjectConstraintMergeError and NSValidationErrorCode
                // TODO: Improve CoreData duplicate error detection (use nested error parsing for NSValidationMultipleErrorsError)
                debugPrint("[CarRepository] Failed to save car, duplicate object: \(error.localizedDescription).")
                context.rollback()
                throw RepositoryError.duplicateObject
            } else {
                debugPrint("[CarRepository] Failed to save car: \(error.localizedDescription).")
                context.rollback()
                throw RepositoryError.createFailed
            }
        }
    }

    func getCar(carID: UUID) throws -> CarModel {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", carID as CVarArg)

        do {
            guard let entity = try context.fetch(fetchRequest).first else {
                debugPrint("[CarRepository] Car with ID \(carID) not found.")
                throw RepositoryError.carNotFound
            }
            return CarMapper.mapToModel(entity: entity)
        } catch {
            debugPrint("[CarRepository] Failed to fetch car with ID \(carID): \(error.localizedDescription).")
            throw RepositoryError.fetchFailed
        }
    }

    func fetchAllCars() throws -> [CarModel] {
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

    func updateCar(_ car: CarModel) throws {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", car.id as CVarArg)

        do {
            guard let entity = try context.fetch(fetchRequest).first else {
                throw RepositoryError.carNotFound
            }

            CarMapper.mapToCoreData(carModel: car, entity: entity)

            do {
                try context.save()
            } catch let error as NSError {
                if error.domain == NSCocoaErrorDomain && (error.code == 133021 || error.code == 1550) {
                    debugPrint("[CarRepository] Failed to update car, duplicate VIN.")
                    context.rollback()
                    throw RepositoryError.duplicateObject
                } else {
                    debugPrint("[CarRepository] Failed to update car: \(error.localizedDescription)")
                    throw RepositoryError.updateFailed
                }
            }

        } catch {
            debugPrint("[CarRepository] Failed to fetch car for update: \(error.localizedDescription)")
            throw RepositoryError.fetchFailed
        }
    }

    func updateMileage(for car: CarModel, newMileage: Int32) throws {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", car.id as CVarArg)
        do {
            guard let entity = try context.fetch(fetchRequest).first else {
                throw RepositoryError.carNotFound
            }
            entity.mileage = newMileage
            try context.save()
        } catch {
            debugPrint("[CarRepository] Failed to update mileage: \(error.localizedDescription).")
            context.rollback()
            throw RepositoryError.updateFailed
        }
    }

    func changeImage(for car: CarModel, image: Data) throws {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", car.id as CVarArg)

        do {
            guard let entity = try context.fetch(fetchRequest).first else {
                throw RepositoryError.carNotFound
            }

            entity.photoCar = image
            try context.save()
        } catch {
            debugPrint("[CarRepository] Failed to update image Car: \(error.localizedDescription).")
            context.rollback()
            throw RepositoryError.updateFailed
        }
    }


    func deleteCar(_ car: CarModel) throws {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", car.id as CVarArg)
        do {
            guard let entity = try context.fetch(fetchRequest).first else {
                throw RepositoryError.carNotFound
            }
            context.delete(entity)
            try context.save()
        } catch {
            debugPrint("[CarRepository] Failed to delete car: \(error.localizedDescription)")
            context.rollback()
            throw RepositoryError.deleteFailed
        }
    }
}


protocol CarRepositoryProtocol {
    func createCar(_ carModel: CarModel) throws -> CarModel

    func fetchAllCars() throws -> [CarModel]
    
    func getCar(carID: UUID) throws -> CarModel

    func updateCar(_ car: CarModel) throws

    func updateMileage(for car: CarModel, newMileage: Int32) throws
    
    func changeImage(for car: CarModel, image: Data) throws
    
    func deleteCar(_ car: CarModel) throws
}
