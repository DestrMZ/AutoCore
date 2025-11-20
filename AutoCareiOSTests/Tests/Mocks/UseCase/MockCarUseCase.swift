//
//  MockCarUseCase.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 20.11.2025.
//

import Foundation
@testable import AutoCareiOS


final class CarUseCaseMock: CarUseCaseProtocol {
    var cars: [CarModel]
    var selectedCar: CarModel?

    var fetchError: Error?
    var initializeError: Error?
    var createError: Error?
    var updateError: Error?
    var mileageError: Error?
    var deleteError: Error?

    init(cars: [CarModel]) {
        self.cars = cars
    }

    func createCar(carModel: CarModel) throws -> CarModel {
        if let createError { throw createError }
        cars.append(carModel)
        return carModel
    }

    func selectCar(car: CarModel) {
        selectedCar = car
    }

    func initializeCar(cars: [CarModel]) throws -> CarModel? {
        if let initializeError { throw initializeError }
        return cars.first
    }

    func fetchAllCars() throws -> [CarModel] {
        if let fetchError { throw fetchError }
        return cars
    }

    func updateCar(carModel: CarModel) throws {
        if let updateError { throw updateError }
        guard let index = cars.firstIndex(where: { $0.id == carModel.id }) else { return }
        cars[index] = carModel
    }

    func updateMileage(for car: CarModel?, newMileage: Int32?) throws {
        if let mileageError { throw mileageError }
        guard let car, let mileage = newMileage, let index = cars.firstIndex(where: { $0.id == car.id }) else { return }
        cars[index].mileage = mileage
    }

    func changeImage(for carModel: CarModel, image: Data) throws {
        guard let index = cars.firstIndex(where: { $0.id == carModel.id }) else { return }
        cars[index].photoCar = image
    }

    func deleteCar(carModel: CarModel) throws {
        if let deleteError { throw deleteError }
        cars.removeAll(where: { $0.id == carModel.id })
    }

    func validateCar(car: CarModel) throws { }
}
