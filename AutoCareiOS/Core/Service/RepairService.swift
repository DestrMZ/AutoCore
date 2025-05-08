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
    
    func creatingRepair(repairDate: Date?, partReplaced: String, amount: Int32, repairMileage: Int32, notes: String?, photoRepair: [Data]?, repairCategory: String, car: Car?, partsDict: [String: String]?) -> Result<Void, RepairErrorStatus> {
        
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
        repair.cars = car
        repair.parts = partsDict
        
        saveContext()
        return .success(())
    }
    
    func getAllRepairs(for car: Car) -> [Repair] {
        let requestRepair: NSFetchRequest<Repair> = Repair.fetchRequest()
        requestRepair.predicate = NSPredicate(format: "cars == %@", car)
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
        
        saveContext()
        return .success(())
    }
    
    
    func deleteRepair(at repair: Repair) {
        context.delete(repair)
        saveContext()
    }
    
    func saveContext() {
        CoreDataStack.shared.saveContent()
    }
}
