//
//  RepairViewModel.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import Foundation
import PhotosUI
import CoreData


// Этот класс помогает создавать, получать и удалять записи о ремонте.
class RepairViewModel: ObservableObject {
    
    // Экземпляр базы данных для работы с данными.
    var db = CoreDataManaged.shared
    
    @Published var repairDate = Date()
    @Published var partReplaced = ""
    @Published var amount: Int32? = nil
    @Published var repairMileage: Int32? = nil
    @Published var notes: String = ""
    @Published var photoRepair: Data = Data()
    @Published var repairCategory: RepairCategory = .service
    
    // Автомобиль, для которого делается ремонт.
    @Published var car: Car? = nil
    // Список всех ремонтов для данного автомобиля.
    @Published var repairArray: [Repair] = []
    // Словарь для записей деталей [article: name]
    @Published var partsDictionary: [String: String] = [:]
    
    // Создает новый ремонт для указанного автомобиля.
    //
    // - Parameter car: Автомобиль, для которого создается ремонт.
    func createNewRepair(for car: Car?, partReplaced: String, amount: Int32?, repairDate: Date?, repairMileage: Int32?, notes: String, photoRepair: Data?, repairCategory: RepairCategory, partsDict: [String: String]) {
        guard let car = car else { return }
        
        // Создаем новый repair в базе данных
        db.creatingRepair(
            repairDate: repairDate,
            partReplaced: partReplaced,
            amount: amount,
            repairMileage: repairMileage,
            notes: notes,
            photoRepair: photoRepair,
            repairCategory: repairCategory.rawValue,
            car: car,
            partsDict: partsDict)
        
        // Получаем все ремонты для данного автомобиля
        getRepairs(for: car)
    }
    
    // Получает все ремонты для указанного автомобиля.
    //
    // - Parameter car: Автомобиль, для которого требуется ремонты.
    func getRepairs(for car: Car) {
        let requestRepairs = db.fetchAllRepairs(for: car)
        
        do {
            DispatchQueue.main.async {
                self.repairArray = requestRepairs
            }
        }
    }
    
    // Получает фотографию ремонта.
    //
    // - Parameter repair: Ремонт, для которого нужна фотография.
    // - Returns: Фотография или `nil`, если она не найдена.
    func getPhotoRepair(repair: Repair) -> UIImage? {
        let image = db.fetchImageRepairCoreData(repair: repair)
        return image // Возвращаем найденную фотографию
    }
    
    // Удаляет указанный ремонт из базы данных.
    //
    // - Parameter repair: Ремонт, который нужно удалить.
    func deleteRepair(_ repair: Repair) {
        db.deleteRepair(repair: repair) // Удаляем ремонт
        
        if let index = repairArray.firstIndex(where: { $0.id == repair.id }) {
            repairArray.remove(at: index)
            print("INFO: Ремонт успешно удален из массива -> (RepairViewModel)")
        } else {
            print("WARNING: Ошибка удаления ремонта!")
        }
        
        db.saveContent()
        
    }
    
    // Удаляет ремонты из списка по указанным индексам.
    //
    // - Parameter offset: Индексы ремонтов, которые нужно удалить.
    func deteteRepairFromList(at offset: IndexSet) {
        offset.forEach { index in
            let repair = self.repairArray[index]
            db.deleteRepair(repair: repair)
            self.repairArray.remove(at: index)
        }
        db.saveContent() // Сохраняем изменения
        print("INFO: Ремонт успешно удален -> (RepairViewModel)")
    }
    
    // MARK: Method for working with dictionary(Parts)
    
    func addPart(for parts: inout [Part]) {
        parts.append(Part(article: "", name: ""))
    }
    
    func removePart(for parts: inout [Part], to index: Int) {
        parts.remove(at: index)
    }
    
    func savePart(parts: [Part]) -> [String: String] {
        var partsDict: [String: String] = [:]
        for part in parts {
            partsDict[part.article] = part.name
        }
        return partsDict
    }
    
    func getParts(for repair: Repair) -> [(article: String, name: String)] {
        return partsDictionary.map { ($0.key, $0.value)
        }
    }
}
