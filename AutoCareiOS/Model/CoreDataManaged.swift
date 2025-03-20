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
                print("WARNING: Ошибка загрузки Persistent Container: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: Метод для сохранения данных в CoreData
    
    func saveContent() {
        let context = persistentContainer.viewContext
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("WARNING: Ошибка сохранения: \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: Методы для создания модели
    
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
        saveVin(vinNumber: vinNumber ?? "")
        
        saveContent()
        print("INFO: Create new car: \(String(describing: car.nameModel)) -> (CoreDataModel)")
    }
    
    func creatingRepair(repairDate: Date?, partReplaced: String?, amount: Int32?, repairMileage: Int32?, notes: String?, photoRepair: [Data]?, repairCategory: String, car: Car?, partsDict: [String: String]?) {
        
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
        
        // Обновление данных пробега авто
        if let repairMileage = repairMileage, let carMileage = car?.mileage {
            if repairMileage > carMileage {
                car?.mileage = repairMileage
            }
        }
        
        saveContent()
        print("IFNO: Create new repair: \(String(describing: repair.partReplaced))")
    }
 
    // MARK: Методы для получения данных из CoreData
    
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
    
    func saveVin(vinNumber: String) {
        let requesVinStore: NSFetchRequest<VinStore> = VinStore.fetchRequest()
        
    
        let vinStore = try? context.fetch(requesVinStore).first ?? VinStore(context: context)
        var vinNumbers = vinStore?.allVinNumbers ?? []
        vinNumbers.append(vinNumber)
        vinStore?.allVinNumbers = vinNumbers
        print("INFO: VIN Number сохранен -> \(String(describing: vinNumber))")
    }
        
    func removeVinNumber(_ vinNumber: String) {
        let requestVinNumber: NSFetchRequest<VinStore> = VinStore.fetchRequest()
        
        do {
            let vinStores = try context.fetch(requestVinNumber)
            
            if let vinStore = vinStores.first {
                if var _ = vinStore.allVinNumbers, let index = vinStore.allVinNumbers?.firstIndex(of: vinNumber) {
                    vinStore.allVinNumbers?.remove(at: index)
                    print("UPDATE: Новый массив \(String(describing: vinStore.allVinNumbers))")
                }
            }
        } catch {
            print("WARNING: Ошибка при удалении VIN-номера: \(error.localizedDescription)")

        }
    }
    
    func fetchAllVinNumbers() -> [String] {
        let requestVinNumbers: NSFetchRequest<VinStore> = VinStore.fetchRequest()
        do {
            let vinNumbers = try context.fetch(requestVinNumbers)
            if vinNumbers.first != nil {
                print("INFO: Все VIN: \(vinNumbers)")
                return vinNumbers.first?.allVinNumbers ?? []
            } else { return [] }
        } catch {
            print("WARNING: Ошибка при извлечении VIN-номеров: \(error.localizedDescription)")
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
    
    
    func saveImagesRepairToCoreData(images: [UIImage]) {
        var tempArray: [Data] = []
        
        guard !images.isEmpty else {
                print("WARNING: Передан пустой массив изображений.")
                return
            }
        
        for image in images {
            let imageData = image.jpegData(compressionQuality: 0.1)
            tempArray.append(imageData!)
        }
        
        let repair = Repair(context: CoreDataManaged.shared.context)
        repair.photoRepair = tempArray
        
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
    
    func fetchImagesRepairCoreData(repair: Repair) -> [UIImage] {
        var tempArray: [UIImage] = []
        if let imagesData = repair.photoRepair {
            
            for image in imagesData {
                if let imageData = UIImage(data: image) {
                    tempArray.append(imageData)
                }
            }
        }
        return tempArray
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
