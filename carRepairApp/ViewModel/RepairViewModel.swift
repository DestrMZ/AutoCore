//
//  RepairViewModel.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import Foundation


class RepairViewModel: ObservableObject {
    
    @Published var repairDate = Date()
    @Published var partReplaced = "Unknown"
    @Published var cost: Double = 0
    @Published var repairMileage: Int32 = 99999
    @Published var repairShop: String = "Unknown"
    @Published var nextServiceDate: Date? = Date()
    @Published var notes: String = "Unknown"
    @Published var car: Car? = nil
    
    
    func createNewRepair() {
        guard self.car != nil else {
            print("К сожалению, не указан автомобиль")
            return
        }
        
        CoreDataManaged.shared.creatingRepair(
            repairDate: self.repairDate,
            partReplaced: self.partReplaced,
            cost: self.cost,
            repairMileage: self.repairMileage,
            repairShop: self.repairShop,
            nextServiceDate: self.nextServiceDate,
            notes: self.notes,
            car: self.car)
    }
    
    func getAllRepair(for car: Car) -> [Repair] {
        let requstAllRepair = CoreDataManaged.shared.fetchAllRepair(for: car)
        return requstAllRepair
    }
    
    func deleteRepair(_ repair: Repair) {
        CoreDataManaged.shared.deleteRepair(repair: repair)
    }
}
