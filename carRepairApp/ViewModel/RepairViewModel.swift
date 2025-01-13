//
//  RepairViewModel.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import Foundation
import PhotosUI
import CoreData
import DGCharts


// Этот класс помогает создавать, получать и удалять записи о ремонте.
class RepairViewModel: ObservableObject {
    
    // Экземпляр базы данных для работы с данными.
    var db = CoreDataManaged.shared
    
    @Published var repairDate = Date()
    @Published var partReplaced = ""
    @Published var amount: Int32? = nil
    @Published var repairMileage: Int32? = nil
    @Published var notes: String = ""
    @Published var photoRepair: [Data] = [Data()]
    @Published var repairCategory: RepairCategory = .service
    
    
    @Published var car: Car? = nil
    
    @Published var repairArray: [Repair] = []

    @Published var partsDictionary: [String: String] = [:]
    
    // Создает новый ремонт для указанного автомобиля.
    func createNewRepair(for car: Car?, partReplaced: String, amount: Int32?, repairDate: Date?, repairMileage: Int32?, notes: String, photoRepair: [Data]?, repairCategory: RepairCategory, partsDict: [String: String]) {
        guard let car = car else { return }
        
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
        
        getAllRepairs(for: car)
    }
    
    // Получает все ремонты для указанного автомобиля.
    func getAllRepairs(for car: Car) {
        let requestRepairs = db.fetchAllRepairs(for: car)
        self.repairArray = requestRepairs
    }
    
    // Получает фотографию ремонта.
    func getPhotosRepair(repair: Repair) -> [UIImage]? {
        let images = db.fetchImagesRepairCoreData(repair: repair)
        return images
    }
    
    // Удаляет указанный ремонт из базы данных.
    func deleteRepair(_ repair: Repair) {
        db.deleteRepair(repair: repair)
        
        if let index = repairArray.firstIndex(where: { $0.id == repair.id }) {
            repairArray.remove(at: index)
            print("INFO: Ремонт успешно удален из массива")
        } else {
            print("WARNING: Ошибка удаления ремонта!")
        }
        
        db.saveContent()
        
    }
    
    // Удаляет ремонты из списка по указанным индексам.
    func deteteRepairFromList(at offset: IndexSet) {
        offset.forEach { index in
            let repair = self.repairArray[index]
            db.deleteRepair(repair: repair)
            self.repairArray.remove(at: index)
        }
        db.saveContent()
        print("INFO: Repair успешно удален.)")
    }
    
    // MARK: Method for working with dictionary(Parts)
    
    // Метод добавляет новый элемент Part с пустыми значениями в массив parts
    func addPart(for parts: inout [Part]) {
        parts.append(Part(article: "", name: ""))
    }
    
    // Метод удаляет элемент из массива parts по индексу
    func removePart(for parts: inout [Part], to index: Int) {
        parts.remove(at: index)
    }
    
    // Метод сохраняет массив Part в словарь, где ключ — артикул, а значение — название
    func savePart(parts: [Part]) -> [String: String] {
        var partsDict: [String: String] = [:]
        
        for part in parts {
            partsDict[part.article] = part.name
        }
        
        return partsDict
    }
    
    // Метод возвращает массив кортежей (артикул, название) из partsDictionary
    func getParts(for repair: Repair) -> [(article: String, name: String)] {
        return partsDictionary.map { ($0.key, $0.value) }
    }
    
    // Метод возвращает массив PieChartDataEntry, содержащий категории ремонтов и их суммы для заданного периода
    func getRepairCategoriesAndAmounts(for car: Car, selectPeriod: FilterDate) -> [PieChartDataEntry] {
        var categoriesAmount: [String: Int] = [:]
        let filter = filterRepairs(filter: selectPeriod)
        
        for repair in filter {
            let categories = NSLocalizedString(repair.repairCategory ?? "nil", comment: "")
            let amount = Int(repair.amount)
            
            if let existingKey = categoriesAmount[categories] {
                categoriesAmount[categories] = existingKey + amount
            } else {
                categoriesAmount[categories] = amount
            }
        }
        
        let sorterDict = categoriesAmount.sorted { $0.key < $1.key }
        return sorterDict.map { (key, value) in
            PieChartDataEntry(value: Double(value), label: key)
        }
    }
    
    // Метод возвращает массив BarChartDataEntry для построения графика, показывающего суммы ремонтов по месяцам
    func getMonthlyExpenses(for car: Car) -> [BarChartDataEntry] {
        var monthAmount: [Int: Double] = [
            1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0, 11: 0, 12: 0
        ]
        
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let repairs = repairArray.filter { // Фильтруем и выбираем ремонты только текущего года
            let repairYear = Calendar.current.component(.year, from: $0.repairDate ?? Date())
            return repairYear == currentYear
        }
        
        for repair in repairs {
            let date = Calendar.current.component(.month, from: repair.repairDate ?? Date())
            let amount = Double(repair.amount)
            
            monthAmount[date, default: 0] += amount
        }
        
        let sortArray = monthAmount.sorted { $0.key < $1.key }
        return sortArray.map { (key, value) in
            BarChartDataEntry(x: Double(key), y: value)
        }
    }
    
    func getTrendLine(for car: Car, period: Int = 3) -> [ChartDataEntry] {
        let monthlyExpenses = getMonthlyExpenses(for: car)
        let expensesValue = monthlyExpenses.map { $0.y }
        
        var trendValues: [Double] = []
        for i in 0..<expensesValue.count {
            if i < period {
                trendValues.append(expensesValue[i])
            } else {
                let sum = expensesValue[(i - period + 1)...i].reduce(0, +)
                trendValues.append(sum / Double(period))
            }
        }
        return trendValues.enumerated().map { index, value in
            ChartDataEntry(x: Double(index + 1), y: value)
        }
    }
    
    // Метод возвращает словарь категорий ремонтов и их сумм для заданного периода
    func getRepairsCategoriesAndAmount(for car: Car, selectedPeriod: FilterDate) -> [String: Int] {
        var categoriesAndAmount: [String: Int] = [:]
        let filterCategoriesAndAmount = filterRepairs(filter: selectedPeriod)
        
        for repair in filterCategoriesAndAmount {
            let cat = repair.repairCategory ?? "nil"
            let amount = Int(repair.amount)
            
            if let existingKey = categoriesAndAmount[cat] {
                categoriesAndAmount[cat] = existingKey + amount
            } else {
                categoriesAndAmount[cat] = amount
            }
        }
        
        return categoriesAndAmount
    }
    
    // Метод возвращает общую сумму ремонтов за заданный период
    func totalAmountFilter(for car: Car, selectedPeriod: FilterDate) -> Int {
        var amount: Int = 0
        let filterRepairForAmount = filterRepairs(filter: selectedPeriod)
        
        for repair in filterRepairForAmount {
            amount += Int(repair.amount)
        }
        return amount
    }
    
    // Метод фильтрует ремонты по выбранному периоду времени
    func filterRepairs(filter: FilterDate) -> [Repair] {
        let currentDate = Date()
        
        switch filter {
        case .week:
            let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: currentDate) ?? Date()
            return repairArray.filter { $0.repairDate ?? Date() > oneWeekAgo && $0.repairDate ?? Date() <= currentDate }
        case .month:
            let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? Date()
            return repairArray.filter { $0.repairDate ?? Date() > oneMonthAgo && $0.repairDate ?? Date() <= currentDate }
        case .year:
            let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: currentDate) ?? Date()
            return repairArray.filter { $0.repairDate ?? Date() > oneYearAgo && $0.repairDate ?? Date() <= currentDate }
        case .allTime:
            let allTimeAgo = Calendar.current.date(byAdding: .year, value: -3, to: currentDate) ?? Date()
            return repairArray.filter { $0.repairDate ?? Date() > allTimeAgo }
        case .custom(startDate: let startDate, endDate: let endDate):
            
            let startOfDay = Calendar.current.startOfDay(for: startDate)
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: endDate)?.addingTimeInterval(-1) ?? endDate
            return repairArray.filter {
                guard let repairDate = $0.repairDate else { return false }
                return repairDate >= startOfDay && repairDate <= endOfDay
            }
        }
    }
}
