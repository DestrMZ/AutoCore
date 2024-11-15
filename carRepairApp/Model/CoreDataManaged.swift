//
//  CoreDataManaged.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import Foundation
import CoreData
import PhotosUI


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
    
    // MARK: Method for save model in CoreData
    
    func saveContent() {
        let context = persistentContainer.viewContext
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("WARNING: Ошибка сохранения: \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: Methods for creating models
    
    func creatingCar(nameModel: String?, year: Int16?, vinNumber: String?, color: String?, mileage: Int32?, engineType: String?, transmissionType: String?, photoCar: Data?) {
        
        let car = Car(context: CoreDataManaged.shared.context)
        car.nameModel = nameModel ?? "Unknow"
        car.year = year ?? 1990
        car.vinNumber = vinNumber ?? "Unknow VIN Number"
        car.color = color ?? "Unknow Color"
        car.mileage = mileage ?? 0
        car.engineType = engineType ?? "Unknow Engine Type"
        car.transmissionType = transmissionType ?? "Unknow Transmission Type"
        car.photoCar = photoCar
        saveVinNumber(vinNumber ?? "")
        
        saveContent()
        print("INFO: Create new car: \(String(describing: car.nameModel)) -> (CoreDataModel)")
    }
    
    func creatingRepair(repairDate: Date?, partReplaced: String?, amount: Int32?, repairMileage: Int32?, notes: String?, photoRepair: Data?, repairCategory: String, car: Car?, partsDict: [String: String]?) {
        
        let repair = Repair(context: CoreDataManaged.shared.context)
        
        repair.repairDate = repairDate ?? Date()
        repair.partReplaced = partReplaced ?? "Unknow Part Replaced"
        repair.amount = amount ?? 0
        repair.repairMileage = repairMileage ?? 0
        repair.notes = notes ?? "Unknow Notes"
        repair.photoRepair = photoRepair
        repair.repairCategory = repairCategory
        repair.cars = car
        repair.parts = partsDict
        
        saveContent()
        print("IFNO: Create new repair: \(String(describing: repair.partReplaced)) for \(String(describing: repair.cars))")
    }
 
    // MARK: Methods for get models
    
    func fetchFirstCar() -> Car? {
        let requestCar: NSFetchRequest<Car> = Car.fetchRequest()
        requestCar.fetchLimit = 1
        do {
            let car = try context.fetch(requestCar)
            return car.first
        } catch {
            print("WARNING: Ошибка при запросе к CoreData, нет найденного автомобиля")
            return nil
        }
    }
    
    func fetchAllCars() -> [Car] {
        let requestCar: NSFetchRequest<Car> = Car.fetchRequest()
        do {
            return try context.fetch(requestCar)
        } catch {
            print("WARNING: Ошибка при запросе к CoreData, нет найденных автомобиля")
            return []
        }
    }
    
    func fetchAllRepairs(for car: Car) -> [Repair] {
        let requestRepair: NSFetchRequest<Repair> = Repair.fetchRequest()
        requestRepair.predicate = NSPredicate(format: "cars == %@", car)
        do {
            return try context.fetch(requestRepair)
        } catch {
            print("WARNING: К сожалению, ничего не найдено из ремонта")
            return []
        }
    }
    
    // MARK: Methods for working with VinStore
    // Для управления, удаления и конроля всех Vin-номеров авто, для избежания дубликатов, и для более удобного построения логики программы
    
//    func saveVinNumber(_ vinNumber: String) {
//        let requestVinNumber: NSFetchRequest<VinStore> = VinStore.fetchRequest()
//        
//        do {
//            let vinStores = try context.fetch(requestVinNumber)
//            
//            if let vinStore = vinStores.first {
//                var vinNumbers = vinStore.allVinNumbers ?? []
//                vinNumbers.append(vinNumber)
//                vinStore.allVinNumbers = vinNumbers
//                print("INFO: VIN-номер \(vinNumber) добавлен.")
//                print("INFO: Массив \(String(describing: vinStore.allVinNumbers))")
//            } else { print("Error!") }
//        } catch {
//            print("ERROR: Ошибка при добавлении VIN-номера: \(error.localizedDescription)")
//        }
//    }
    
    
    // FIXME: Переписать метод
    func saveVinNumber(_ vinNumber: String) {
        let requestVinNumber: NSFetchRequest<VinStore> = VinStore.fetchRequest()
        
        do {
            let vinStore: VinStore
            
            let vinStores = try context.fetch(requestVinNumber)
            
            if let existingVinStore = vinStores.first {
                vinStore = existingVinStore
            } else {
                vinStore = VinStore(context: context)
            }
            
            var vinNumbers = vinStore.allVinNumbers ?? []
            vinNumbers.append(vinNumber)
            vinStore.allVinNumbers = vinNumbers
            print("INFO: VIN-номер \(vinNumber) добавлен.")
            print("INFO: Массив \(String(describing: vinStore.allVinNumbers))")
        } catch {
            print("ERROR: Ошибка при добавлении VIN-номера: \(error.localizedDescription)")
        }
    }
    
    
    
    
    func removeVinNumber(_ vinNumber: String) {
        let requestVinNumber: NSFetchRequest<VinStore> = VinStore.fetchRequest()
        
        do {
            let vinStores = try context.fetch(requestVinNumber)
            
            if let vinStore = vinStores.first {
                if var _ = vinStore.allVinNumbers, let index = vinStore.allVinNumbers?.firstIndex(of: vinNumber) {
                    vinStore.allVinNumbers?.remove(at: index)
                    print("INFO: Vin-номер \(vinNumber) был удален. По индексу \(index).")
                    print("UPDATE: Новый массив \(String(describing: vinStore.allVinNumbers))")
                }
            }
        } catch {
            print("ERROR: Ошибка при удалении VIN-номера: \(error.localizedDescription)")

        }
    }
    
    func fetchAllVinNumbers() -> [String] {
        let requestVinNumbers: NSFetchRequest<VinStore> = VinStore.fetchRequest()
        do {
            let vinNumbers = try context.fetch(requestVinNumbers)
            if vinNumbers.first != nil {
                print("Все VIN-номера \(vinNumbers)")
                return vinNumbers.first?.allVinNumbers ?? []
            } else { return [] }
        } catch {
            print("ERROR: Ошибка при извлечении VIN-номеров: \(error.localizedDescription)")
            return []
        }
    }

    // MARK: Сохранение изображения ремонта в Core Data
    
    func saveImageCarToCoreData(image: UIImage, for car: Car?) {
        guard let car = car else { return }
        guard let imageDataCar = image.jpegData(compressionQuality: 0.1) else { return }
        
        car.photoCar = imageDataCar

        do {
            try CoreDataManaged.shared.context.save()
            print("INFO: Изображение автомобиля успешно сохранено.")
        } catch {
            print("WARNING: Ошибка при сохранении изображения автомобиля: \(error.localizedDescription)")
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
            print("WARNING: Ошибка сохранения изображения поломки: \(error.localizedDescription)")
        }
    }
    
    func fetchImageCarFromCoreData(car: Car) -> UIImage? {
        if let photoData = car.photoCar {
            return UIImage(data: photoData)
        }
        return nil
    }
    
    func fetchImageRepairCoreData(repair: Repair) -> UIImage? {
        if let imageData = repair.photoRepair {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    // MARK: Methods for delete from CoreData
    
    func deleteCar(car: Car) {
        if let vinNumber = car.vinNumber {
            removeVinNumber(vinNumber)
        }
        persistentContainer.viewContext.delete(car)
        saveContent()
    }
    
    func deleteRepair(repair: Repair) {
        persistentContainer.viewContext.delete(repair)
        saveContent()
    }
}
