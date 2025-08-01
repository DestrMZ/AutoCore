//
//  CarViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 24.06.2025.
//

import Foundation
import UIKit


class CarViewModel: ObservableObject {
    
    private let carUseCase: CarUseCaseProtocol
    private let sharedCarStore: SharedCarStoreProtocol
    
    init(carUseCase: CarUseCaseProtocol, sharedCarStore: SharedCarStoreProtocol) {
        self.carUseCase = carUseCase
        self.sharedCarStore = sharedCarStore
        
        initializeCar()
    }
    
//    @Published var nameModel: String = ""
//    @Published var year: Int16 = 0
//    @Published var vinNumber: String = ""
//    @Published var color: String? = nil
//    @Published var mileage: Int32 = 0
//    @Published var engineType: EngineTypeEnum = .gasoline
//    @Published var transmissionType: TransmissionTypeEnum = .automatic
//    @Published var photoCar: Data = Data()
//    @Published var stateNumber: String = ""
//    
//    @Published var alertMessage: String = ""
//    @Published var isShowAlert: Bool = false
    
    @Published var cars: [CarModel] = []
    
    @Published var selectedCar: CarModel? {
        didSet {
            if let car = selectedCar {
                carUseCase.selectCar(car: car)
                populate(from: car)
            }
        }
    }
  
    func fetchCars() {
        do {
            let result = try carUseCase.fetchAllCars()
            self.cars = result
        } catch {
            alertMessage = error.localizedDescription
            isShowAlert = true
        }
    }
     
    func initializeCar() {
        fetchCars()
        
        do {
            if let currentCar = try carUseCase.initializeCar(cars: self.cars) {
                selectedCar = currentCar
                debugPrint("[CarViewModel] Initialized car: \(String(describing: currentCar.nameModel))")
            } else {
                selectedCar = nil
                debugPrint("[CarViewModel] No cars available.")
            }
        } catch CarError.initializeFailed {
            selectedCar = cars.last
            alertMessage = CarError.initializeFailed.localizedDescription
            isShowAlert = true
            debugPrint("[CarViewModel] Fallback to last car in list.")
        } catch {
            alertMessage = error.localizedDescription
            isShowAlert = true
            debugPrint("[CarViewModel] Unexpected error during initializeCar: \(error.localizedDescription)")
        }
    }
    
    func populate(from carModel: CarModel) {
        self.nameModel = carModel.nameModel
        self.year = carModel.year
        self.vinNumber = carModel.vinNumbers
        self.color = carModel.color
        self.mileage = carModel.mileage
        self.engineType = EngineTypeEnum(rawValue: carModel.engineType) ?? .gasoline
        self.transmissionType = TransmissionTypeEnum(rawValue: carModel.transmissionType) ?? .manual
        self.photoCar = carModel.photoCar as Data
        self.stateNumber = carModel.stateNumber ?? ""
    }
    
//    func addCar(newCar: CarModel) {
//        do {
//            let result = try carUseCase.createCar(carModel: newCar)
//            self.cars.append(result)
//        } catch let error as CarError {
//            alertMessage = error.localizedDescription
//            isShowAlert = true
//        } catch {
//            alertMessage = error.localizedDescription
//            isShowAlert = true
//        }
//    }
    
    func updateCar(carModel: CarModel) {
        do {
            try carUseCase.updateCar(carModel: carModel)
        } catch let error as CarError {
            alertMessage = error.localizedDescription
            isShowAlert = true
        } catch {
            alertMessage = error.localizedDescription
            isShowAlert = true
        }
    }
    
    func updateMileage(for carModel: CarModel, newMileage: Int32) {
        do {
            try carUseCase.updateMileage(for: carModel, newMileage: newMileage)
        } catch let error as CarError {
            alertMessage = error.localizedDescription
            isShowAlert = true
        } catch {
            alertMessage = error.localizedDescription
            isShowAlert = true
        }
    }
    
    func changePhotoCar(image: UIImage) {
        guard let car = self.selectedCar else { return }
        let data = image.jpegData(compressionQuality: 1) ?? Data()
        
        do {
            try carUseCase.changeImage(for: car, image: data)
            // Продумать обновление состояние UI
        } catch let error as CarError {
            alertMessage = error.localizedDescription
            isShowAlert = true
        } catch {
            alertMessage = error.localizedDescription
            isShowAlert = true
        }
    }
    
    func deleteCar(carModel: CarModel) {
        do {
            try carUseCase.deleteCar(carModel: carModel)
            if let index = cars.firstIndex(of: carModel) {
                cars.remove(at: index)
            }
            selectedCar = nil
        } catch let error as CarError {
            alertMessage = error.localizedDescription
            isShowAlert = true
        } catch {
            alertMessage = error.localizedDescription
            isShowAlert = true
        }
    }
}
