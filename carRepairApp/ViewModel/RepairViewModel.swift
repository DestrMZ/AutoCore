//
//  RepairViewModel.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import Foundation
import PhotosUI


// Этот класс помогает создавать, получать и удалять записи о ремонте.
class RepairViewModel: ObservableObject {
    
    // Экземпляр базы данных для работы с данными.
    var db = CoreDataManaged.shared
    
    @Published var repairDate = Date()
    @Published var partReplaced = ""
    @Published var amount: Int32 = 0
    @Published var repairMileage: Int32 = 0
    @Published var notes: String = ""
    @Published var photoRepair: Data = Data()
    @Published var repairCategory: RepairCategory = .service
    
    // Автомобиль, для которого делается ремонт.
    @Published var car: Car? = nil
    
    // Список всех ремонтов для данного автомобиля.
    @Published var repairArray: [Repair] = []
    
    
    // Создает новый ремонт для указанного автомобиля.
    //
    // - Parameter car: Автомобиль, для которого создается ремонт.
    func createNewRepair(for car: Car?) {
        guard let car = car else { return }
        
        // Создаем новый repair в базе данных
        db.creatingRepair(
            repairDate: self.repairDate,
            partReplaced: self.partReplaced,
            amount: self.amount,
            repairMileage: self.repairMileage,
            notes: self.notes,
            photoRepair: self.photoRepair,
            repairCategory: self.repairCategory.rawValue,
            car: car
        )
        
        // Сохраняем изменения в базе данных
        db.saveContent()
        // Получаем все ремонты для данного автомобиля
        getAllRepair(for: car)

        // Выводим сообщение о успешном создании ремонта
        print("INFO: Ремонт был успешно создан, для авто: \(String(describing: car.nameModel)) -> (RepairViewModel)")
    }
    
    // Получает все ремонты для указанного автомобиля.
    //
    // - Parameter car: Автомобиль, для которого требуется ремонты.
    func getAllRepair(for car: Car) {
        let requstAllRepair = db.fetchAllRepair(for: car)
        self.repairArray = requstAllRepair // Обновляем список ремонтов
        print("INFO: Все repairs для авто -> \(String(describing: car.nameModel))")
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
            db.deleteRepair(repair: repair) // Удаляем ремонт
            self.repairArray.remove(at: index) // Удаляем его из списка
        }
        
        db.saveContent() // Сохраняем изменения
        print("INFO: Ремонт успешно удален -> (RepairViewModel)")
    }
}
