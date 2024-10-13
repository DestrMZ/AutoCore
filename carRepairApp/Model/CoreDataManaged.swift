//
//  CoreDataManaged.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import Foundation
import CoreData
import PhotosUI
import UIKit


class CoreDataManaged {
    
    static let shared = CoreDataManaged()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "carRepairApp")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as? NSError {
                print("Ошибка загрузки Persistent Container: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContent() {
        let context = persistentContainer.viewContext
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Ошибка сохранения: \(nsError), \(nsError.userInfo)")
        }
    }
    
    func creatingCar(nameModel: String?, year: Int16, vinNumber: String?, color: String?, mileage: Int32, dateOfPurchase: Date?, engineType: String?, transmissionType: String?, photoCar: Data?) {
        
        let car = Car(context: CoreDataManaged.shared.context)
        car.nameModel = nameModel ?? "Unknow"
        car.year = year
        car.vinNumber = vinNumber ?? "Unknow VIN Number"
        car.color = color ?? "Unknow Color"
        car.mileage = mileage
        car.dateOfPurchase = dateOfPurchase ?? Date()
        car.engineType = engineType ?? "Unknow Engine Type"
        car.transmissionType = transmissionType ?? "Unknow Transmission Type"
        car.photoCar = photoCar
        
        saveContent()
        print("Новый автомобиль добавлен")
    }
    
    func creatingRepair(repairDate: Date?, partReplaced: String?, cost: Double, repairMileage: Int32, repairShop: String?, nextServiceDate: Date?, notes: String?, photoRepair: Data?, car: Car?) {
        
        let repair = Repair(context: CoreDataManaged.shared.context)
        
        repair.repairDate = repairDate ?? Date()
        repair.partReplaced = partReplaced ?? "Unknow Part Replaced"
        repair.cost = cost
        repair.repairMileage = repairMileage
        repair.repairShop = repairShop ?? "Unknow Repair Shop"
        repair.nextServiceDate = nextServiceDate ?? Date()
        repair.notes = notes ?? "Unknow Notes"
        repair.photoRepair = photoRepair
        repair.cars = car
        
        saveContent()
    }
    
    func getAllCars() -> [Car] {
        let requestCar: NSFetchRequest<Car> = Car.fetchRequest()
        do {
            return try context.fetch(requestCar)
        } catch {
            print("Ошибка при запросе к CoreData, нет найденных автомобиля")
            return []
        }
    }
    
    func fetchCar() -> Car? {
        let requestCar: NSFetchRequest<Car> = Car.fetchRequest()
        requestCar.fetchLimit = 1
        do {
            let car = try context.fetch(requestCar)
            return car.first
        } catch {
            print("Ошибка при запросе к CoreData, нет найденного автомобиля")
            return nil
        }
    }
    
    func fetchAllRepair(for car: Car) -> [Repair] {
        let requestRepair: NSFetchRequest<Repair> = Repair.fetchRequest()
        requestRepair.predicate = NSPredicate(format: "cars == %@", car)
        do {
            return try context.fetch(requestRepair)
        } catch {
            print("К сожалению, ничего не найдено из ремонта")
            return []
        }
    }
    
    func deleteCar(car: Car) {
        persistentContainer.viewContext.delete(car)
    }
    
    func deleteRepair(repair: Repair) {
        persistentContainer.viewContext.delete(repair)
    }
    
    // MARK: Сохранение изображения ремонта в Core Data
    func saveImageCarToCoreData(image: UIImage, for car: Car?) {
        guard let car = car else { return }
        guard let imageDataCar = image.jpegData(compressionQuality: 0.1) else { return }
        func saveImageCarToCoreData(image: UIImage, for car: Car?) {
            guard let car = car else { return } 
            guard let imageDataCar = image.jpegData(compressionQuality: 0.1) else { return }

            car.photoCar = imageDataCar

            do {
                try CoreDataManaged.shared.context.save()
                print("Изображение автомобиля успешно сохранено.")
            } catch {
                print("Ошибка при сохранении изображения автомобиля: \(error.localizedDescription)")
            }
        }
        car.photoCar = imageDataCar

        do {
            try CoreDataManaged.shared.context.save()
            print("Изображение автомобиля успешно сохранено.")
        } catch {
            print("Ошибка при сохранении изображения автомобиля: \(error.localizedDescription)")
        }
    }
    
    // MARK: Получение изображения автомобиля из Core Data
    func saveImageRepairToCoreData(image: UIImage) {
        guard let imageDataRepair = image.jpegData(compressionQuality: 0.1) else { return }
        
        let repair = Repair(context: CoreDataManaged.shared.context)
        repair.photoRepair = imageDataRepair
        
        do {
            try CoreDataManaged.shared.context.save()
        } catch {
            print("Ошибка сохранения изображения поломки: \(error.localizedDescription)")
        }
    }
    
    func fetchImageCarFromCoreData() -> UIImage? {
        if let car = fetchCar() {
            if let imageData = car.photoCar {
                return UIImage(data: imageData)
            }
        }
        return nil
    }
    
    // TODO: Сделать позже
//    func fetchImageRepairFromCoreData() -> UIImage? {
//        let request: NSFetchRequest<Repair> = Repair.fetchRequest()
//        requst.fetchLimit = 1
//    }
}
