//
//  CarStore.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 11.11.2025.
//

import Foundation


@MainActor
final class CarStore: ObservableObject {
    
    private let carUseCase: CarUseCaseProtocol
    
    init(carUseCase: CarUseCaseProtocol) {
        self.carUseCase = carUseCase
    }
    
    @Published private(set) var cars: [CarModel] = []
    @Published private(set) var selectedCar: CarModel? = nil
    
    func loadCars() {
        Task {
            do {
                let fetchedCars = try carUseCase.fetchAllCars()
                let initialCar = try carUseCase.initializeCar(cars: fetchedCars)
                self.cars = fetchedCars
                self.selectedCar = initialCar
            } catch {
                print("[CarStore] Failed to load cars: \(error)")
            }
        }
    }
    
    func selectCar(car: CarModel) {
        self.selectedCar = car
        carUseCase.selectCar(car: car)
    }
    
    func addCar(newCar: CarModel) {
        Task {
            do {
                let created = try carUseCase.createCar(carModel: newCar)
                self.cars.append(created)
            } catch {
                print("[CarStore] Failed to add car: \(error)")
            }
        }
    }
}
