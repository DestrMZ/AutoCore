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
    
    func createCar(car: CarModel) async throws -> CarModel {
        
        if car.nameModel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw CarValidationError.missingNameModel
        }
        
        if car.vinNumbers.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw CarValidationError.missingVinNumber
        }
        
        if car.year <= 0 {
            throw CarValidationError.missingYear
        }
        
        if car.mileage <= 0 {
            throw CarValidationError.missingMileage
        }
        
        switch vinRepository.getVins() {
        case .success(let vins):
            guard !vins.contains(car.vinNumbers) else {
                throw CarValidationError.duplicateVinNumber
            }
        
            switch vinRepository.addVin(vin: car.vinNumbers) {
            case .success:
            case .failure:
                throw CarStorageError.vinNumberSaveFailed
            }
        case .failure:
            throw CarStorageError.saveFailed
        }
        
        switch carRepository.createCar(car) {
        case .success(let car):
            return car
        case .failure:
            throw CarStorageError.saveFailed
        }
    }
    
    func getAllCars() async throws -> [CarModel] {
        switch carRepository.getAllCars() {
        case .success(let cars):
            return cars
        case .failure:
            throw CarStorageError.fetchFailed
        }
    }
    
    func updateMileage(for car: CarModel?, newMileage: Int32?) async throws {
        guard let car = car else { throw UpdateMileageUseCaseError.carNotFound }
        guard let mileage = newMileage else { throw UpdateMileageUseCaseError.invalidData }
        guard mileage > 0 else { throw UpdateMileageUseCaseError.numberNonNegative }
        guard mileage < 5_000_000 else { throw UpdateMileageUseCaseError.exceedsMaximumValue }
        
        switch carRepository.updateMileage(for: car, newMileage: mileage) {
        case .success:
        case .failure(let error):
            throw UpdateMileageUseCaseError.updateMileageFailed
        }
    }
    
    func updateCar(car: CarModel) async throws {
        if car.nameModel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw CarValidationError.missingNameModel
        }
        
        if car.vinNumbers.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw CarValidationError.missingVinNumber
        }
        
        if car.year <= 0 {
            throw CarValidationError.missingYear
        }
        
        if car.mileage <= 0 {
            throw CarValidationError.missingMileage
        }
       
        switch vinRepository.getVins() {
        case .success(let vins):
            if !vins.contains(car.vinNumbers) {
                debugPrint("[WARNING] VIN number was changed or missing from store — re-adding it")
                _ = vinRepository.addVin(vin: car.vinNumbers)
            }
        case .failure:
            throw CarStorageError.saveFailed
        }

        switch carRepository.updateCar(car) {
        case .success:
        case .failure:
            throw CarStorageError.updateFailed
        }
    }
    
    func deleteCar(car: CarModel) async throws {
        switch carRepository.deleteCar(car) {
        case .success:
            
            switch vinRepository.deleteVin(vin: car.vinNumbers) {
            case .success:
            case .failure:
                throw CarStorageError.fetchFailed
            }
        case .failure:
            throw CarStorageError.deleteFailed
        }
    }
}


protocol CarUseCaseProtocol {
    func createCar(car: CarModel) async throws -> CarModel
    
    func getAllCars() async throws -> [CarModel]
    
    func updateCar(car: CarModel) async throws
    
    func updateMileage(for car: CarModel?, newMileage: Int32?) async throws

    func deleteCar(car: CarModel) async throws
    
    
}
