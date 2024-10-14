//
//  ManagerViewModel.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import Foundation
import PhotosUI


class CarViewModel: ObservableObject {
    
    // Добавить db
    
    @Published var nameModel: String = ""
    @Published var year: Int16 = 1990
    @Published var vinNumber: String = ""
    @Published var color: String = ""
    @Published var mileage: Int32 = 100
    @Published var dateOfPurchase = Date()
    @Published var engineType: EngineTypeEnum = .gasoline
    @Published var transmissionType: TransmissionTypeEnum = .manual
    @Published var photoCar: Data = Data()
    
    
    func createNewCar() {
        
        CoreDataManaged.shared.creatingCar(
            nameModel: self.nameModel,
            year: self.year,
            vinNumber: self.vinNumber,
            color: self.color,
            mileage: self.mileage,
            dateOfPurchase: self.dateOfPurchase,
            engineType: self.engineType.rawValue,
            transmissionType: self.transmissionType.rawValue,
            photoCar: self.photoCar
            )
        
        CoreDataManaged.shared.saveContent()
        print("Успешно создан новый объект(Car).")
        
        print("Name model: \(nameModel)")
        print("Year: \(year)")
        print("Vin number: \(vinNumber)")
        print("Color: \(color)")
        print("Mileage: \(mileage)")
        print("Date of purchse: \(dateOfPurchase)")
        print("Engine type: \(engineType)")
        print("Transmission type: \(transmissionType)")
        
    }
    
    func loadCarInfo() {
        
        if let carFromCoreData = getCar() {
            self.nameModel = carFromCoreData.nameModel ?? ""
            self.year = carFromCoreData.year
            self.vinNumber = carFromCoreData.vinNumber ?? ""
            self.color = carFromCoreData.color ?? ""
            self.mileage = carFromCoreData.mileage
            self.dateOfPurchase = carFromCoreData.dateOfPurchase ?? Date()
            self.engineType = EngineTypeEnum(rawValue: carFromCoreData.engineType ?? "") ?? .gasoline
            self.transmissionType = TransmissionTypeEnum(rawValue: carFromCoreData.transmissionType ?? "") ?? .manual
            
            print("Автомобиль найден")
        } else {
            print("Автомобиль не найден")
        }
        
    }
    
    func getCar() -> Car? {
        let requestCar = CoreDataManaged.shared.fetchCar()
        return requestCar
    }
    
    func deleteCar() {
        guard let car = getCar() else { return
            print("Автомобиль для удаления не найден") }
        CoreDataManaged.shared.deleteCar(car: car)
        print("Увтомобиль успешно удален")
        
    }
    
    func resetCarInfo() {
        nameModel = ""
        year = 1990
        vinNumber = ""
        color = ""
        mileage = 100
        dateOfPurchase = Date()
        engineType = .gasoline
        transmissionType = .manual
    }
    
    
    // MARK: Methdos for job with photoUI
    func saveImageCar(imageSelection: UIImage) {
        if let car = CoreDataManaged.shared.fetchCar() {
            CoreDataManaged.shared.saveImageCarToCoreData(image: imageSelection, for: car)
        } else {
            print("Автомобиль не найден для сохранения изображения.")
        }
    }
    
    func getImageCar() -> UIImage? {
        let image = CoreDataManaged.shared.fetchImageCarFromCoreData()
        return image
    }
}
