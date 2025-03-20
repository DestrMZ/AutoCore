//
//  ManagerViewModel.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import Foundation
import PhotosUI

// CarViewModel управляет информацией об автомобиле.
class CarViewModel: ObservableObject {
    
    // Экземпляр базы данных для работы с данными.
    private var db = CoreDataManaged.shared
    
    @Published var nameModel: String = ""
    @Published var year: Int16? = nil
    @Published var vinNumber: String = ""
    @Published var color: String = ""
    @Published var mileage: Int32? = nil
    @Published var engineType: EngineTypeEnum = .gasoline
    @Published var transmissionType: TransmissionTypeEnum = .manual
    @Published var photoCar: Data = Data()
    
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
    
    // Метод для инициализации приложения и логика работы с selectedCar
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
    
    // Получаем весь массив VIN номеров из CoreData
    func getAllVinArray() -> [String]? {
        let vinNumbers = db.fetchAllVinNumbers()
        return vinNumbers
    }
    
    // Метод для сохраениния в UserDefaults последний выбранный автомобиль
    func saveLastSelectAuto() {
        if let selectedCar = selectedCar {
            UserDefaults.standard.set(selectedCar.vinNumber, forKey: "currentAuto")
            print("Saved VIN: \(selectedCar.vinNumber ?? "Unknown")")
        }
    }
    
    // Создает новый автомобиль
    func createNewCar(nameModel: String, year: Int16?, vinNumber: String?, color: String?, mileage: Int32?, engineType: EngineTypeEnum, transmissionType: TransmissionTypeEnum, photoCar: UIImage) {
        
        db.creatingCar(
            nameModel: nameModel,
            year: year,
            vinNumber: vinNumber,
            color: color,
            mileage: mileage,
            engineType: engineType.rawValue,
            transmissionType: transmissionType.rawValue,
            photoCar: photoCar.jpegData(compressionQuality: 0.8) ?? Data()
        )
        
        let allVins = getAllVinArray()
        print(allVins ?? [])
        
        db.saveContent()
        getAllCars()
        
        if let newCar = allCars.last {
            selectedCar = newCar
        }
    }
    
    func editCar(for car: Car, nameModel: String, year: Int16?, vinNumber: String?, color: String?, mileage: Int32?, engineType: EngineTypeEnum, transmissionType: TransmissionTypeEnum, photoCar: UIImage) {
    
        if let carVIN = car.vinNumber, let newCarVIN = vinNumber, carVIN != newCarVIN {
            db.removeVinNumber(carVIN)
            print("VIN DELETE - \(carVIN)")
            db.saveVin(vinNumber: newCarVIN)
            print("VIN SAVE - \(newCarVIN)")
            
            if let allVIN = getAllVinArray() {
                print(allVIN)
            }
        }
        
        // FIXME:
        
        car.nameModel = nameModel
        car.year = year ?? 2000
        car.vinNumber = vinNumber ?? "Not enter VIN"
        car.color = color ?? "Default"
        car.mileage = mileage ?? 1000
        car.engineType = engineType.rawValue
        car.transmissionType = transmissionType.rawValue
        car.photoCar = photoCar.jpegData(compressionQuality: 0.8) ?? Data()
    
        
        db.saveContent()
        print("INFO: Car \(nameModel) updated successfully.")
    }
    
    // Загружает информацию о конкретном автомобиле.
    func loadCarInfo(for car: Car) {
        self.nameModel = car.nameModel ?? ""
        self.year = car.year
        self.vinNumber = car.vinNumber ?? ""
        self.color = car.color ?? ""
        self.mileage = car.mileage
        self.engineType = EngineTypeEnum(rawValue: car.engineType ?? "") ?? .gasoline
        self.transmissionType = TransmissionTypeEnum(rawValue: car.transmissionType ?? "") ?? .manual
    }
    
    // Загружает все автомобили из базы данных.
    func getAllCars() {
        let requestAllCars = db.fetchAllCars()
        self.allCars = requestAllCars
    }
    
    // Сохраняет фотографию автомобиля в базе данных.
    func saveImageCar(imageSelection: UIImage) {
        if let car = selectedCar {
            db.saveImageCarToCoreData(image: imageSelection, for: car)
        } else {
            print("WARNING: Нет авто для сохранения изображения.")
        }
    }
    
    // Получает фотографию автомобиля.
    func getImageCar(for car: Car) -> UIImage? {
        let image = db.fetchImageCarFromCoreData(car: car)
        return image
    }
    
    // Удаляет автомобили из списка по указанным индексам.
    func deleteCarFromList(at offset: IndexSet) {
        print("INFO: Автомобиль \(nameModel) удален.")
        offset.forEach { index in
            let car = self.allCars[index]
            db.deleteCar(car: car)
            self.allCars.remove(at: index)
            selectedCar = nil

        }
        db.saveContent()
    }
}


extension Notification.Name {
    static let didChangeSelectedCar = Notification.Name("didChangeSelectedCar")
}
