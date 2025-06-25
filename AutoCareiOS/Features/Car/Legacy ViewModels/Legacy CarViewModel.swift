//
//  ManagerViewModel.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import Foundation
import PhotosUI


class LegacyCarViewModel: ObservableObject {
    
    private var carService = CarDataService()
    
    @Published var nameModel: String = ""
    @Published var year: Int16? = nil
    @Published var vinNumber: String = ""
    @Published var color: String = ""
    @Published var mileage: Int32? = nil
    @Published var engineType: EngineTypeEnum = .gasoline
    @Published var transmissionType: TransmissionTypeEnum = .manual
    @Published var photoCar: Data = Data()
    @Published var stateNumber: String = ""
    
    @Published var alertMessage: String = ""
    @Published var alertShow: Bool = false
    
    @Published var allCars: [Car] = []
    
    @Published var selectedCar: Car? {
        didSet {
            if let car = selectedCar {
                saveLastSelectAuto()
                loadCarInfo(for: car)
                NotificationCenter.default.post(name: .didChangeSelectedCar, object: nil, userInfo: ["selectedCar": car])
            }
            else if !allCars.isEmpty {
                selectedCar = allCars.last
            }
        }
    }
    
    func initializeCarRepairApp() {
        
        getAllCars()
        
        if allCars.isEmpty {
            print("WARNING: No cars found in database")
            return
        }
        
        if let lastSelectAuto = UserDefaults.standard.string(forKey: "currentAuto") {
            if let car = allCars.first( where: { $0.vinNumber == lastSelectAuto}) {
                self.selectedCar = car
                print("Successfully loaded last selected car: \(car.nameModel ?? "Unknown"), VIN: \(car.vinNumber ?? "Unknown")")
            } else {
                if !allCars.isEmpty {
                    print("WARNING: Saved VIN \(lastSelectAuto) not found in current cars")
                    self.selectedCar = allCars.last
                }
            }
        }
    }
    
    func saveLastSelectAuto() {
        if let selectedCar = selectedCar {
            UserDefaults.standard.set(selectedCar.vinNumber, forKey: "currentAuto")
            print("Saved VIN: \(selectedCar.vinNumber ?? "Unknown")")
        }
    }
    
    func createNewCar(nameModel: String, year: Int16, vinNumber: String, color: String?, mileage: Int32?, engineType: EngineTypeEnum, transmissionType: TransmissionTypeEnum, photoCar: UIImage, stateNumber: String?) {
        
        alertShow = false
        
        let result = carService.creatingCar(
            nameModel: nameModel,
            year: year,
            vinNumber: vinNumber,
            color: color ?? "Black",
            mileage: mileage ?? 1000,
            engineType: engineType.rawValue,
            transmissionType: transmissionType.rawValue,
            photoCar: photoCar.jpegData(compressionQuality: 0.8),
            stateNumber: stateNumber
            
        )
        
        switch result {
        case .success(let car):
            selectedCar = car
            getAllCars()
        case .failure(let error):
            alertMessage = error.localizedDescription
            alertShow = true
        }
    }
    
    
    func editingCar(for car: Car, nameModel: String, year: Int16?, vinNumber: String?, color: String?, mileage: Int32?, engineType: EngineTypeEnum, transmissionType: TransmissionTypeEnum, photoCar: UIImage) {
        
        alertShow = false
        
        let result = carService.updateCar(
            car: car,
            nameModel: nameModel,
            year: year,
            vinNumber: vinNumber,
            color: color,
            mileage: mileage,
            engineType: engineType.rawValue,
            transmissionType: transmissionType.rawValue,
            photoCar: photoCar.jpegData(compressionQuality: 0.8)
        )
        
        switch result {
        case .success(let car):
            selectedCar = car
            getAllCars()
        case .failure(let error):
            alertMessage = error.localizedDescription
            alertShow = true
        }
    }
    
    func loadCarInfo(for car: Car) {
        self.nameModel = car.nameModel ?? ""
        self.year = car.year
        self.vinNumber = car.vinNumber ?? ""
        self.color = car.color ?? ""
        self.mileage = car.mileage
        self.engineType = EngineTypeEnum(rawValue: car.engineType) ?? .gasoline
        self.transmissionType = TransmissionTypeEnum(rawValue: car.transmissionType) ?? .manual
        self.photoCar = car.photoCar ?? Data()
        self.stateNumber = car.stateNumber ?? "Empty"
    }
    
    func getAllCars() {
        let getAllCars = carService.getAllCars()
        self.allCars = getAllCars
    }

    func saveImageCar(imageSelection: UIImage, for car: Car) {
        if let car = self.selectedCar {
            car.photoCar = imageSelection.jpegData(compressionQuality: 0.8)
            carService.saveContext()
            print("Изображение автомобиля \(car.nameModel ?? "Unknown") изменено!")
        } else {
            print("Ошибка при сохранении изображения автомобиля!")
        }
    }
    
    func deleteCar(at offset: IndexSet) {
        print("INFO: Автомобиль \(nameModel) удален.")
        offset.forEach { index in
            let car = self.allCars[index]
            
            carService.deleteCar(car: car)
            
            self.allCars.remove(at: index)
            selectedCar = nil
        }
    }
    
    func updateMileage(for car: Car, mileage: Int32) -> (success: Bool, message: String) {
        let result = carService.updateMileage(for: car, mileage: mileage)
        
        switch result {
        case .success:
            self.mileage = mileage
            
            return (true, "Success")
        case .failure(let error):
            return (false, error.localizedDescription)
        }
    }
}
        


//extension Notification.Name {
//    static let didChangeSelectedCar = Notification.Name("didChangeSelectedCar")
//}
