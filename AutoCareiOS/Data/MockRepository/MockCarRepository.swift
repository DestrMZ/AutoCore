//
//  MockCarRepository.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 17.07.2025.
//

import Foundation


final class MockCarRepository: CarRepositoryProtocol {
    
    var mockCars: [CarModel] = []
    var shouldFail: Bool = false
    
    
    func createCar(_ carModel: CarModel) throws -> CarModel {
        if shouldFail {
            throw RepositoryError.fetchFailed
        }
        mockCars.append(carModel)
        return carModel
    }
    
    func fetchAllCars() throws -> [CarModel] {
        if shouldFail {
            throw RepositoryError.fetchFailed
        }
        return mockCars
    }
    
    func getCar(carID: UUID) throws -> CarModel {
        if shouldFail {
            throw RepositoryError.fetchFailed
        }
        guard let car = mockCars.first(where: { $0.id == carID }) else {
            throw RepositoryError.carNotFound
        }
        return car
    }
    
    func updateCar(_ car: CarModel) throws {
        if shouldFail {
            throw RepositoryError.updateFailed
        }
        guard let index = mockCars.firstIndex(where: { $0.id == car.id }) else {
            throw RepositoryError.carNotFound
        }
        mockCars[index] = car
    }
    
    func updateMileage(for car: CarModel, newMileage: Int32) throws {
        if shouldFail {
            throw RepositoryError.updateFailed
        }
        guard let index = mockCars.firstIndex(where: { $0.id == car.id }) else {
            throw RepositoryError.carNotFound
        }
        
        var updatedCar = mockCars[index]
        updatedCar.mileage = newMileage
        mockCars[index] = updatedCar
    }
    
    func changeImage(for car: CarModel, image: Data) throws {
        if shouldFail {
            throw RepositoryError.updateFailed
        }
        guard let index = mockCars.firstIndex(where: { $0.id == car.id }) else {
            throw RepositoryError.carNotFound
        }
        
        var updateCar = mockCars[index]
        updateCar.photoCar = image
        mockCars[index] = updateCar
    }
    
    func deleteCar(_ car: CarModel) throws {
        if shouldFail {
            throw RepositoryError.deleteFailed
        }
        mockCars.removeAll(where: { $0.id == car.id })
    }
}
