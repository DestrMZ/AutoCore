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
    
    func createCar(carModel: CarModel) throws -> CarModel {
        try validateCar(car: carModel)
        let vins = try vinRepository.getVins()
        guard !vins.contains(carModel.vinNumbers) else {
            throw CarError.duplicateVinNumber
        }
        
        do {
            let car = try carRepository.createCar(carModel)
            try vinRepository.addVin(vin: carModel.vinNumbers)
            debugPrint("[CarUseCase] \(carModel.nameModel) successful created!")
            return car
        } catch {
            throw CarError.saveFailed
        }
    }
    
    func fetchAllCars() throws -> [CarModel] {
        do {
            return try carRepository.getAllCars()
        } catch {
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
        } catch {
            throw CarError.mileageUpdateFailed
        }
    }
    
    func updateCar(carModel: CarModel) throws -> CarModel {
        try validateCar(car: carModel)
        
        let vins: [String]
        let oldCarModel: CarModel
        
        do {
            vins = try vinRepository.getVins()
        } catch {
            throw CarError.vinAccessFailed
        }
        
        do {
            oldCarModel = try carRepository.getCar(carID: carModel.id)
        } catch {
            throw CarError.carNotFound
        }
        
        if oldCarModel.vinNumbers != carModel.vinNumbers {
            if vins.contains(carModel.vinNumbers) {
                throw CarError.duplicateVinNumber
            }
        }
        
        do {
            let updatedCar = try carRepository.updateCar(carModel)

            if oldCarModel.vinNumbers != carModel.vinNumbers {
                try vinRepository.deleteVin(vin: oldCarModel.vinNumbers)
                try vinRepository.addVin(vin: carModel.vinNumbers)
                debugPrint("[CarUseCase] VIN updated from \(oldCarModel.vinNumbers) to \(carModel.vinNumbers)")
            }

            debugPrint("[CarUseCase] \(carModel.nameModel) successfully updated!")
            return updatedCar
        } catch {
            throw CarError.updateFailed
        }
    }
    
    func deleteCar(carModel: CarModel) throws {
        do {
            try carRepository.deleteCar(carModel)
            try vinRepository.deleteVin(vin: carModel.vinNumbers)
            debugPrint( "[CarUseCase] \(carModel.nameModel) successful deleted!")
        } catch {
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
    
    func fetchAllCars() throws -> [CarModel]
    
    func updateCar(carModel: CarModel) throws -> CarModel
    
    func updateMileage(for car: CarModel?, newMileage: Int32?) throws

    func deleteCar(carModel: CarModel) throws
    
    func validateCar(car: CarModel) throws
}
