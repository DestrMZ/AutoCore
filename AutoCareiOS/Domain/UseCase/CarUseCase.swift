//
//  CarUseCase.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 18.06.2025.
//

import Foundation
import Combine


final class CarUseCase: CarUseCaseProtocol {
    
    private let carRepository: CarRepositoryProtocol
    private let userStoreRepository: UserStoreRepositoryProtocol
    
    let selectedCarPublisher: PassthroughSubject<CarModel, Never> = .init()
    
    init(carRepository: CarRepositoryProtocol, userStoreRepository: UserStoreRepositoryProtocol) {
        self.carRepository = carRepository
        self.userStoreRepository = userStoreRepository
    }
    
    func selectCar(car: CarModel) {
        userStoreRepository.saveLastSelectedVin(car.vinNumbers)
        selectedCarPublisher.send(car)
    }
    
    func initializeCar(cars: [CarModel]) throws -> CarModel {
        
        guard !cars.isEmpty else {
            throw CarError.fetchFailed
        }
        
        if let lastSelectedVin = userStoreRepository.loadLastSelectedVin(), let matchedCar = cars.first(where: { $0.vinNumbers == lastSelectedVin })  {
            return matchedCar
        }
        
        throw CarError.initializeFailed
    }
    
    func createCar(carModel: CarModel) throws -> CarModel {
        try validateCar(car: carModel)
        
        do {
            let carModel = try carRepository.createCar(carModel)
            debugPrint("[CarUseCase] \(carModel.nameModel) successfully created!")
            return carModel
        } catch RepositoryError.duplicateObject {
            throw CarError.duplicateVinNumber
        } catch RepositoryError.createFailed {
            throw CarError.createFailed
        }
    }
    
    func fetchAllCars() throws -> [CarModel] {
        do {
            return try carRepository.fetchAllCars()
        } catch RepositoryError.fetchFailed {
            throw CarError.fetchFailed
        }
    }
    
    func updateMileage(for carModel: CarModel?, newMileage: Int32?) throws {
        guard let car = carModel else { throw CarError.carNotFound }
        guard let mileage = newMileage else { throw CarError.missingMileage }
        guard mileage > 0 else { throw CarError.mileageNegative }
        guard mileage < 5_000_000 else { throw CarError.mileageExceedsLimit }
        
        do {
            debugPrint("[CarUseCase] \(String(describing: newMileage)) mileage updated for \(car.nameModel) successfully!")
            try carRepository.updateMileage(for: car, newMileage: mileage)
        } catch RepositoryError.carNotFound {
            throw CarError.carNotFound
        } catch RepositoryError.updateFailed {
            throw CarError.mileageUpdateFailed
        }
    }
    
    func updateCar(carModel: CarModel) throws {
        try validateCar(car: carModel)
        
        let oldCarModel: CarModel
        do {
            oldCarModel = try carRepository.getCar(carID: carModel.id)
        } catch RepositoryError.carNotFound {
            throw CarError.carNotFound
        } catch RepositoryError.fetchFailed {
            throw CarError.fetchFailed
        }

        do {
            if oldCarModel.vinNumbers != carModel.vinNumbers {
                debugPrint("[CarUseCase] VIN updated from \(oldCarModel.vinNumbers) to \(carModel.vinNumbers)")
            }
            try carRepository.updateCar(carModel)
        } catch RepositoryError.duplicateObject {
            throw CarError.duplicateVinNumber
        } catch {
            debugPrint("[CarUseCase] Unexpected error during update: \(error.localizedDescription)")
            throw CarError.updateFailed
        }
    }
    
    func changeImage(for carModel: CarModel, image: Data) throws {
        do {
            try carRepository.changeImage(for: carModel, image: image)
        } catch RepositoryError.carNotFound {
            throw CarError.carNotFound
        } catch RepositoryError.updateFailed {
            throw CarError.updateFailed
        }
    }
    
    func deleteCar(carModel: CarModel) throws {
        do {
            try carRepository.deleteCar(carModel)
            debugPrint( "[CarUseCase] \(carModel.nameModel) successful deleted!")
        } catch RepositoryError.carNotFound {
            throw CarError.carNotFound
        } catch RepositoryError.deleteFailed {
            throw CarError.deleteFailed
        }
    }
    
    func validateCar(car: CarModel) throws {
        if car.nameModel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw CarError.missingNameModel
        }
        
        if car.vinNumbers.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw CarError.missingVinNumber
        }
        
        if car.year <= 0 {
            throw CarError.missingYear
        }
        
        if car.mileage <= 0 {
            throw CarError.missingMileage
        }
    }
}


protocol CarUseCaseProtocol {
    func createCar(carModel: CarModel) throws -> CarModel
    
    func selectCar(car: CarModel)
    
    func initializeCar(cars: [CarModel]) throws -> CarModel
    
    func fetchAllCars() throws -> [CarModel]
    
    func updateCar(carModel: CarModel) throws
    
    func updateMileage(for car: CarModel?, newMileage: Int32?) throws

    func changeImage(for carModel: CarModel, image: Data) throws
    
    func deleteCar(carModel: CarModel) throws
    
    func validateCar(car: CarModel) throws
}
