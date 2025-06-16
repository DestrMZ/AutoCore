//
//  RepairDataService.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 20.04.2025.
//

import Foundation
import CoreData
import UIKit


final class RepairDataService {
    
    private let context = CoreDataStack.shared.context
    
    func creatingRepair(repairDate: Date?, partReplaced: String, amount: Int32, repairMileage: Int32, notes: String?, photoRepair: [Data]?, repairCategory: String, car: Car?, partsDict: [String: String]?, litresFuel: Double?) -> Result<Void, RepairErrorStatus> {
        
        guard !partReplaced.isEmpty else { return .failure(.missingPartReplaced) }
        guard amount >= 0 else { return .failure(.invalidAmount) }
        guard repairMileage >= 0 else { return .failure(.invalidMileage) }
        
        let repair = Repair(context: context)
        repair.repairDate = repairDate ?? Date()
        repair.partReplaced = partReplaced
        repair.amount = amount
        repair.repairMileage = repairMileage
        repair.notes = notes ?? ""
        repair.photoRepair = photoRepair
        repair.repairCategory = repairCategory
        repair.car = car
        repair.parts = partsDict
        repair.litresFuel = NSNumber(value: litresFuel ?? 0)
        
        saveContext()
        return .success(())
    }
    
    func getAllRepairs(for car: Car) -> [Repair] {
        let requestRepair: NSFetchRequest<Repair> = Repair.fetchRequest()
        requestRepair.predicate = NSPredicate(format: "car == %@", car)
        do {
            return try context.fetch(requestRepair)
        } catch {
            print("WARNING: К сожалению, ничего не найдено из ремонта")
            return []
        }
    }
    
    func updateRepair(for repair: Repair?, repairDate: Date?, partReplaced: String?, amount: Int32?, repairMileage: Int32?, notes: String?, photoRepair: [Data]?, repairCategory: String?, partsDict: [String: String]?
    ) -> Result<Void, RepairErrorStatus> {
        
        guard let repair = repair else { return .failure(.repairNotFound) }
        guard let partReplaced = partReplaced, !partReplaced.isEmpty else { return .failure(.missingPartReplaced) }
        guard let amount = amount, amount >= 0 else { return .failure(.invalidAmount) }
        guard let repairMileage = repairMileage, repairMileage >= 0 else { return .failure(.invalidMileage) }
        
        repair.repairDate = repairDate ?? repair.repairDate
        repair.partReplaced = partReplaced
        repair.amount = amount
        repair.repairMileage = repairMileage
        repair.notes = notes ?? repair.notes
        repair.photoRepair = photoRepair ?? repair.photoRepair
        repair.repairCategory = repairCategory ?? repair.repairCategory
        repair.parts = partsDict ?? repair.parts
        #warning("При добавлении функционала по редактированию ремонта, ты не передаешь litresFuel")
        
        saveContext()
        return .success(())
    }
    
    func fetchLatestRefueling(for car: Car?, repairs: [Repair]) -> (litres: String, date: Date) {
        let repairsFuel = repairs.filter { $0.repairCategory == "Fuel" && $0.repairDate != nil }
        
        if let latest = repairsFuel.max(by: { $0.repairDate < $1.repairDate ?? Date() }) {
            let dateRefuel = latest.repairDate
            let litresRefuel = String(format: "%.1f", Double(truncating: latest.litresFuel ?? 0))
            
            return (litres: litresRefuel, date: dateRefuel ?? Date.now)
        }
        return (litres: "10", date: Date.now)
    }
    
    func deleteRepair(at repair: Repair) {
        context.delete(repair)
        saveContext()
    }
    
    func saveContext() {
        CoreDataStack.shared.saveContent()
    }
}
