//
//  CarStore.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 11.11.2025.
//

import Foundation
import UIKit


@MainActor
final class CarStore: ObservableObject {

    private let carUseCase: CarUseCaseProtocol

    @Published private(set) var cars: [CarModel] = []
    @Published private(set) var selectedCar: CarModel?

    init(carUseCase: CarUseCaseProtocol) {
        self.carUseCase = carUseCase
    }

    func loadCars() throws {
        let fetchedCars = try self.carUseCase.fetchAllCars()
        let initial = try self.carUseCase.initializeCar(cars: fetchedCars)
        
        self.cars = fetchedCars
        self.selectedCar = initial
    }
    
    func selectCar(_ car: CarModel) {
        self.selectedCar = car
        carUseCase.selectCar(car: car)
    }
    
    func addCar(car: CarModel) throws {
        let newCar = try self.carUseCase.createCar(carModel: car)
        self.cars.append(newCar)
    }
    
    func updateCar(car: CarModel) throws {
        try self.carUseCase.updateCar(carModel: car)
        
        if let index = self.cars.firstIndex(where: { $0.id == car.id }) {
            cars[index] = car
        }
    }
    
    func updateMileage(for car: CarModel, newMileage: Int32) throws {
        try carUseCase.updateMileage(for: car, newMileage: newMileage)
        
        if let index = self.cars.firstIndex(where: { $0.id == car.id }) {
            var updatedCar = self.cars[index]
            updatedCar.mileage = newMileage
            cars[index] = updatedCar
        }
    }
    
    func changeImage(for carModel: CarModel, image: Data) throws {
        try carUseCase.changeImage(for: carModel, image: image)
        
        if let index = cars.firstIndex(where: { $0.id == carModel.id }) {
            var updated = carModel
            updated.photoCar = image
            cars[index] = updated
            if selectedCar?.id == carModel.id {
                selectedCar = updated
            }
        }
    }
    
    func deleteCar(_ carModel: CarModel) throws {
        try carUseCase.deleteCar(carModel: carModel)
        
        if let index = cars.firstIndex(of: carModel) {
            cars.remove(at: index)
        }
        if selectedCar == carModel {
            selectedCar = nil
        }
    }
}
