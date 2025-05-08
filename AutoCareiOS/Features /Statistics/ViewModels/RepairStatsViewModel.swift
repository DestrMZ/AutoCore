//
//  RepairStatsViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 21.04.2025.
//

import Foundation
import DGCharts


struct RepairStatsCalculator {
    
    var repairs: [Repair]
    
    func getRepairCategoriesAndAmounts(selectPeriod: FilterDate) -> [PieChartDataEntry] {
        var categoriesAmount: [String: Int] = [:]
        let filter = filterRepairs(filter: selectPeriod)
        
        for repair in filter {
            let categories = NSLocalizedString(repair.repairCategory ?? "Unknown", comment: "")
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
    
    // Метод возвращает массив BarChartDataEntry для построения графика, показывающе#imageLiteral(resourceName: "Screenshot 2025-05-04 at 12.30.34 PM.png")го суммы ремонтов по месяцам
    func getMonthlyExpenses() -> [BarChartDataEntry] {
        var monthAmount: [Int: Double] = [
            1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0, 11: 0, 12: 0
        ]
        
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let repairs = repairs.filter { // Фильтруем и выбираем ремонты только текущего года
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
    
    func getTrendLine(period: Int = 3) -> [ChartDataEntry] {
        let monthlyExpenses = getMonthlyExpenses()
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
    func getRepairsCategoriesAndAmount(selectedPeriod: FilterDate) -> [String: Int] {
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
    func totalAmountFilter(selectedPeriod: FilterDate) -> Int {
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
            return repairs.filter { $0.repairDate ?? Date() > oneWeekAgo && $0.repairDate ?? Date() <= currentDate }
        case .month:
            let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? Date()
            return repairs.filter { $0.repairDate ?? Date() > oneMonthAgo && $0.repairDate ?? Date() <= currentDate }
        case .year:
            let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: currentDate) ?? Date()
            return repairs.filter { $0.repairDate ?? Date() > oneYearAgo && $0.repairDate ?? Date() <= currentDate }
//        case .allTime:
//            let allTimeAgo = Calendar.current.date(byAdding: .year, value: .max, to: currentDate) ?? Date()
//            return repairVM.repairArray.filter { $0.repairDate ?? Date() > allTimeAgo }
        case .allTime:
            return repairs
        case .custom(startDate: let startDate, endDate: let endDate):
            
            let startOfDay = Calendar.current.startOfDay(for: startDate)
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: endDate)?.addingTimeInterval(-1) ?? endDate
            return repairs.filter {
                guard let repairDate = $0.repairDate else { return false }
                return repairDate >= startOfDay && repairDate <= endOfDay
            }
        }
    }
    
}
