//
//  ManagerViewModel.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import Foundation
import PhotosUI

// `CarViewModel` управляет информацией об автомобиле.
// Этот класс помогает создавать, загружать и удалять автомобили.
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
    
    // Список всех автомобилей.
    @Published var allCars: [Car] = []
    
    // Выбранный автомобиль.
    @Published var selectedCar: Car? {
        didSet {
            if let car = selectedCar {
                loadCarInfo(for: car) // Загружаем информацию о выбранном автомобиле
                print("INFO: Выбран: \(String(describing: car.nameModel)) -> (CarViewModel)")
                saveLastSelectCar()
            }
        }
    }
    
    // Метод для сохраениния в UserDefaults последний выбранный автомобиль
    func saveLastSelectCar() {
        if let lastSelectCar = selectedCar {
            UserDefaults.standard.set(lastSelectCar.vinNumber, forKey: "lastSelectedCarVIN")
        }
    }
    
    // При запуске приложения, подгружает последни выбранный автомобиль
    func loadLastSelectCar() {
        if let lastSelectCar = UserDefaults.standard.string(forKey: "lastSelectedCarVIN") {
            if let car = allCars.first(where: { $0.vinNumber == lastSelectCar }) {
                print("INFO: При запуске приложения, загружен авто \(String(describing: car.nameModel))")
                DispatchQueue.main.async {
                    self.selectedCar = car // Вариант решения проблемы с тестом на реальном устройстве
                }
            }
        }
    }
    
    // Создает новый автомобиль с введенными данными.
    func createNewCar(nameModel: String, year: Int16?, vinNumber: String?, color: String?, mileage: Int32?, engineType: EngineTypeEnum, transmissionType: TransmissionTypeEnum, photoCar: UIImage) {
        
        // Создаем новый автомобиль в базе данных
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
        
        db.saveContent() 
        getAllCars()
    }
    
    // Загружает информацию о конкретном автомобиле.
    //
    // - Parameter car: Автомобиль, информацию о котором нужно загрузить.
    func loadCarInfo(for car: Car) {
        self.nameModel = car.nameModel ?? ""
        self.year = car.year
        self.vinNumber = car.vinNumber ?? ""
        self.color = car.color ?? ""
        self.mileage = car.mileage
        self.engineType = EngineTypeEnum(rawValue: car.engineType ?? "") ?? .gasoline
        self.transmissionType = TransmissionTypeEnum(rawValue: car.transmissionType ?? "") ?? .manual
    }
    
    // Получает первый автомобиль из базы данных.
    //
    // - Returns: Автомобиль или `nil`, если он не найден.
    func getFirstCarArray() -> Car? {
        let requestCar = db.fetchFirstCar()
        return requestCar
    }
    
    // Загружает все автомобили из базы данных.
    func getAllCars() {
        let requestAllCars = db.fetchAllCars()
        self.allCars = requestAllCars // Обновляем список автомобилей
    }
    
    // Сохраняет фотографию автомобиля в базе данных.
    //
    // - Parameter imageSelection: Фотография автомобиля.
    func saveImageCar(imageSelection: UIImage) {
        if let car = selectedCar {
            db.saveImageCarToCoreData(image: imageSelection, for: car) // Сохраняем изображение для первого автомобиля
        } else {
            print("WARNING: Нет авто для сохранения изображения -> (CarViewModel).")
        }
    }
    
    // Получает фотографию автомобиля.
    //
    // - Parameter car: Автомобиль, для которого нужна фотография.
    // - Returns: Фотография или `nil`, если она не найдена.
    func getImageCar(for car: Car) -> UIImage? {
        let image = db.fetchImageCarFromCoreData(car: car)
        return image // Возвращаем найденную фотографию
    }
    
    // Удаляет текущий автомобиль из базы данных.
    func deleteCar() {
        guard let car = getFirstCarArray() else {
            print("WARNING: Авто для удаления не найдено -> (CarViewModel)")
            return
        }
        db.deleteCar(car: car) // Удаляем автомобиль
        print("INFO: Авто успешно удалено -> (CarViewModel)")
    }
    
    // Удаляет автомобили из списка по указанным индексам.
    //
    // - Parameter offset: Индексы автомобилей, которые нужно удалить.
    func deleteCarFromList(at offset: IndexSet) {
        print("INFO: Авто на удаление -> \(nameModel)")
        offset.forEach { index in
            let car = self.allCars[index]
            db.deleteCar(car: car) // Удаляем автомобиль
            self.allCars.remove(at: index) // Удаляем его из списка
        }
        db.saveContent() // Сохраняем изменения
    }
}
