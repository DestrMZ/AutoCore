//
//  CarDataService.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 20.04.2025.
//

import Foundation
import CoreData


final class CarDataService {
    
    private let context = CoreDataStack.shared.context
    
    private let vinService = VinStoreService()
    
    func creatingCar(nameModel: String, year: Int16, vinNumber: String, color: String?, mileage: Int32, engineType: String, transmissionType: String, photoCar: Data?, stateNumber: String?) -> Result<Car, CarSaveError> {
        
        if nameModel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .failure(.missingNameModel)
        }
        
        if vinNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .failure(.missingVinNumber)
        }
        
        if year <= 0 {
            return .failure(.missingYear)
        }
        
        if mileage <= 0 {
            return .failure(.missingMileage)
        }
        
        if vinService.getAllVin().contains(vinNumber) {
            return .failure(.duplicateVinNumber)
        }

        let car = Car(context: context)
        car.nameModel = nameModel
        car.year = year
        car.vinNumber = vinNumber
        car.color = color ?? "Unknow Color"
        car.mileage = mileage
        car.engineType = engineType
        car.transmissionType = transmissionType
        car.photoCar = photoCar
        car.stateNumber = stateNumber ?? "Empty"
        
        vinService.addVin(vinNumber: vinNumber)
        
        saveContext()
        return .success(car)
    }
    
    func getAllCars() -> [Car] {
        let requestCar: NSFetchRequest<Car> = Car.fetchRequest()
        do {
            return try context.fetch(requestCar)
        } catch {
            print("WARNING: Ошибка при запросе к CoreData, нет найденных автомобиля")
            return []
        }
    }
    
    func updateCar(car: Car?, nameModel: String?, year: Int16?, vinNumber: String?, color: String?, mileage: Int32?, engineType: String?, transmissionType: String?, photoCar: Data?) -> Result<Car, CarUpdateError>  {
        
        if let car = car {
            car.nameModel = nameModel ?? car.nameModel
            car.year = year ?? car.year
            car.vinNumber = vinNumber ?? car.vinNumber
            car.color = color ?? car.color
            car.mileage = mileage ?? car.mileage
            car.engineType = engineType ?? car.engineType
            car.transmissionType = transmissionType ?? car.transmissionType
            car.photoCar = photoCar ?? car.photoCar
            
            saveContext()
            return .success(car)
        }
        return .failure(.updateFailed)
    }
    
    func updateMileage(for car: Car?, mileage: Int32?) -> Result<Void, UpdateMileageError> {
        guard let car = car else { return .failure(.carNotFound)}
        guard let mileage = mileage else { return .failure(.invalidData)}
        guard mileage >= 0 else { return .failure(.numberNonNegative)}
        guard mileage < 5_000_000 else { return .failure(.exceedsMaximumValue)}
        
        car.mileage = mileage
        
        saveContext()
        return .success(())
    }
    
    func deleteCar(car: Car) {
        context.delete(car)
        vinService.deleteVin(car.vinNumber ?? "")
        saveContext()
    }
    
    func saveContext() {
        CoreDataStack.shared.saveContent()
    }
}
