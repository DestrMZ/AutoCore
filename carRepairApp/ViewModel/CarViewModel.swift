//
//  ManagerViewModel.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import Foundation
import PhotosUI


class CarViewModel: ObservableObject {

    private var db = CoreDataManaged.shared

    @Published var nameModel: String = ""
    @Published var year: Int16 = 1990
    @Published var vinNumber: String = ""
    @Published var color: String = ""
    @Published var mileage: Int32 = 100
    @Published var dateOfPurchase = Date()
    @Published var engineType: EngineTypeEnum = .gasoline
    @Published var transmissionType: TransmissionTypeEnum = .manual
    @Published var photoCar: Data = Data()
    
    @Published var allCars: [Car] = []
    @Published var selectedCar: Car? {
        didSet {
            if let car = selectedCar {
                loadCarInfo(for: car)
                print("Enter: \(String(describing: car.nameModel)) -> (CarViewModel)")
            }
        }
    }
    
    func createNewCar() {
        
        db.creatingCar(
            nameModel: self.nameModel,
            year: self.year,
            vinNumber: self.vinNumber,
            color: self.color,
            mileage: self.mileage,
            engineType: self.engineType.rawValue,
            transmissionType: self.transmissionType.rawValue,
            photoCar: self.photoCar
            )
        
        db.saveContent()
        print("Name model: \(nameModel)")
        print("Year: \(year)")
        print("Vin number: \(vinNumber)")
        print("Color: \(color)")
        print("Mileage: \(mileage)")
        print("Engine type: \(engineType)")
        print("Transmission type: \(transmissionType)")
        
    }
    
    func loadCarInfo(for car: Car) {

        self.nameModel = car.nameModel ?? ""
        self.year = car.year
        self.vinNumber = car.vinNumber ?? ""
        self.color = car.color ?? ""
        self.mileage = car.mileage
        self.engineType = EngineTypeEnum(rawValue: car.engineType ?? "") ?? .gasoline
        self.transmissionType = TransmissionTypeEnum(rawValue: car.transmissionType ?? "") ?? .manual

        print("Car found: \(String(describing: car.nameModel)) -> (CarViewModel)")
    }
    
    func getCar() -> Car? {
        let requestCar = db.fetchFirstCar()
        return requestCar
    }
    
    func getAllCars() {
        let requestAllCars = db.fetchAllCars()
        self.allCars = requestAllCars
    }
    
    func saveImageCar(imageSelection: UIImage) {
        if let car = db.fetchFirstCar() {
            db.saveImageCarToCoreData(image: imageSelection, for: car)
        } else {
            print("No vehicle found to save image -> (CarViewModel).")
        }
    }
    
    func getImageCar(for car: Car) -> UIImage? {
        let image = db.fetchImageCarFromCoreData(car: car)
        return image
    }
    
    func deleteCar() {
        guard let car = getCar() else { return
            print("Car for delet, not found -> (CarViewModel)") }
        db.deleteCar(car: car)
        print("Car successfully deleted -> (CarViewModel)")
    }
    
    func deleteCarFromList(at offset: IndexSet) {
        offset.forEach { index in
            let car = self.allCars[index]
            db.deleteCar(car: car)
            self.allCars.remove(at: index)
        }
        
        db.saveContent()
        print("Car successfully deleted -> (CarViewModel)")
    }
}
