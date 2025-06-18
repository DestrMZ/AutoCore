//
//  CarUseCase.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 18.06.2025.
//

import Foundation


final class CarUseCase: CarUseCaseProtocol {
    
    private let carRepository: CarRepositoryProtocol
    private let vinRepository: VinRepositoryProtocol
    
    init(carRepository: CarRepositoryProtocol, vinRepository: VinRepositoryProtocol) {
        self.carRepository = carRepository
        self.vinRepository = vinRepository
    }
    
    func createCar(car: CarModel) -> Result<Void, CarUseCaseError> {
        
        if car.nameModel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .failure(.missingNameModel)
        }
        
        if car.vinNumbers.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .failure(.missingVinNumber)
        }
        
        if car.year <= 0 {
            return .failure(.missingYear)
        }
        
        if car.mileage <= 0 {
            return .failure(.missingMileage)
        }
        
        switch vinRepository.getVins() {
        case .success(let vins):
            guard !vins.contains(car.vinNumbers) else {
                return .failure(.duplicateVinNumber)
            }
        
            switch vinRepository.addVin(vin: car.vinNumbers) {
            case .success:
                debugPrint("Add new vin - \(car.vinNumbers)")
            case .failure:
                return .failure(.carSaveFailed)
            }
        case .failure:
            return .failure(.carSaveFailed)
        }
        
        switch carRepository.createCar(car) {
        case .success:
            return .success(())
        case .failure:
            return .failure(.carSaveFailed)
        }
    }
    
    func getAllCars() -> Result<[CarModel], CarUseCaseError> {
        switch carRepository.getAllCars() {
        case .success(let cars):
            return .success(cars)
        case .failure:
            return .failure(.getCarsFailed)
        }
    }
    
    func updateMileage(for car: CarModel?, newMileage: Int32?) -> Result<Void, UpdateMileageUseCaseError> {
        guard let car = car else { return .failure(.carNotFound)}
        guard let mileage = newMileage else { return .failure(.invalidData)}
        guard mileage > 0 else { return .failure(.numberNonNegative)}
        guard mileage < 5_000_000 else { return .failure(.exceedsMaximumValue)}
        
        switch carRepository.updateMileage(for: car, newMileage: mileage) {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(.updateMileageFailed)
        }
    }
    
    func updateCar(car: CarModel) -> Result<Void, CarUseCaseError> {
        if car.nameModel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .failure(.missingNameModel)
        }
        
        if car.vinNumbers.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .failure(.missingVinNumber)
        }
        
        if car.year <= 0 {
            return .failure(.missingYear)
        }
        
        if car.mileage <= 0 {
            return .failure(.missingMileage)
        }
       
        switch vinRepository.getVins() {
        case .success(let vins):
            if !vins.contains(car.vinNumbers) {
                debugPrint("[WARNING] VIN number was changed or missing from store — re-adding it")
                _ = vinRepository.addVin(vin: car.vinNumbers)
            }
        case .failure:
            return .failure(.carSaveFailed)
        }

        switch carRepository.updateCar(car) {
        case .success:
            return .success(())
        case .failure:
            return .failure(.updateCarFailed)
        }
    }
    
    func deleteCar(car: CarModel) -> Result<Void, CarUseCaseError> {
        switch carRepository.deleteCar(car) {
        case .success:
            
            switch vinRepository.deleteVin(vin: car.vinNumbers) {
            case .success:
                debugPrint("Delete vin - \(car.vinNumbers)")
            case .failure:
                return .failure(.carSaveFailed)
            }
            
            return .success(())
        case .failure:
            return .failure(.deleteFailed)
        }
    }
}


protocol CarUseCaseProtocol {
    func createCar(car: CarModel) -> Result<Void, CarUseCaseError>
    
    func getAllCars() -> Result<[CarModel], CarUseCaseError>
    
    func updateCar(car: CarModel) -> Result<Void, CarUseCaseError>
    
    func updateMileage(for car: CarModel?, newMileage: Int32?) -> Result<Void, UpdateMileageUseCaseError>

    func deleteCar(car: CarModel) -> Result<Void, CarUseCaseError>
    
    
}
