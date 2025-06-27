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
    private let userDefaultsRepository: UserSettingsRepositoryProtocol
    
    init(carUseCase: CarUseCaseProtocol, userDefaultsRepository: UserSettingsRepositoryProtocol) {
        self.carUseCase = carUseCase
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    @Published var nameModel: String = ""
    @Published var year: Int16 = 0
    @Published var vinNumber: String = ""
    @Published var color: String? = nil
    @Published var mileage: Int32 = 0
    @Published var engineType: EngineTypeEnum = .gasoline
    @Published var transmissionType: TransmissionTypeEnum = .automatic
    @Published var photoCar: Data = Data()
    @Published var stateNumber: String? = nil
    
    @Published var alertMessage: String = ""
    @Published var isShowAlert: Bool = false
    
    @Published var cars: [CarModel] = []
    
    @Published var selectedCar: CarModel? {
        didSet {
            if let vin = selectedCar?.vinNumbers {
                userDefaultsRepository.saveLastSelectedVin(vin)
                NotificationCenter.default.post(name: .didChangeSelectedCar, object: nil, userInfo: ["selectedCar": selectedCar!])
            }
        }
    }
  
    func fetchCars() {
        do {
            let result = try carUseCase.fetchAllCars()
            self.cars = result
        } catch {
            alertMessage = CarError.fetchFailed.localizedDescription
        }
    }
    
    func initializeCarSelection() {
        fetchCars()
        
        guard !cars.isEmpty else {
            return debugPrint("[CarViewModel] No cars found in database.")}
        
        if let lastSelectedVin = userDefaultsRepository.loadLastSelectedVin(), let matchedCar = cars.first(where: { $0.vinNumbers == lastSelectedVin })  {
            selectedCar = matchedCar
            debugPrint("[CarViewModel] Loaded last selected car: \(matchedCar.nameModel), VIN: \(matchedCar.vinNumbers)")
        } else {
            selectedCar = cars.last
            debugPrint("[CarViewModel] Fallback to last car in list.")
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
        self.stateNumber = carModel.stateNumber
    }
    
    func addCar(newCar: CarModel) {
        do {
            let result = try carUseCase.createCar(carModel: newCar)
            self.cars.append(result)
        } catch let error as CarError {
            alertMessage = error.localizedDescription
        } catch {
            alertMessage = "\(error.localizedDescription)"
        }
    }
    
    func updateCar(carModel: CarModel) {
        do {
            try carUseCase.updateCar(carModel: carModel)
        } catch let error as CarError {
            alertMessage = error.localizedDescription
        } catch {
            alertMessage = "\(error.localizedDescription)"
        }
    }
    
    func updateMileage(for carModel: CarModel, newMileage: Int32) {
        do {
            try carUseCase.updateMileage(for: carModel, newMileage: newMileage)
        } catch let error as CarError {
            alertMessage = error.localizedDescription
        } catch {
            alertMessage = "\(error.localizedDescription)"
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
        } catch {
            alertMessage = "\(error.localizedDescription)"
        }
    }
    
    func deleteCar(carModel: CarModel) {
        do {
            try carUseCase.deleteCar(carModel: carModel)
            if let index = cars.firstIndex(of: carModel) {
                cars.remove(at: index)
            }
            selectedCar = nil
        } catch CarError.carNotFound {
            alertMessage = CarError.carNotFound.localizedDescription
        } catch {
            alertMessage = CarError.deleteFailed.localizedDescription
        }
    }
}


extension Notification.Name {
    static let didChangeSelectedCar = Notification.Name("didChangeSelectedCar")
}
