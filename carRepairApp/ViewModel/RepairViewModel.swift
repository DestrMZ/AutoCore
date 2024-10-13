//
//  RepairViewModel.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import Foundation


class RepairViewModel: ObservableObject {
    
    @Published var repairDate = Date()
    @Published var partReplaced = ""
    @Published var cost: Double = 0
    @Published var repairMileage: Int32 = 0
    @Published var repairShop: String = ""
    @Published var nextServiceDate: Date = Date()
    @Published var notes: String = ""
    @Published var photoRepair: Data = Data()
    @Published var car: Car? = nil
    
    @Published var repairArray: [Repair] = []
    
    
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
            photoRepair: self.photoRepair,
            car: self.car)
        
    }
    
    func getAllRepair(for car: Car) {
        let requstAllRepair = CoreDataManaged.shared.fetchAllRepair(for: car)
        self.repairArray = requstAllRepair
    }
    
    func deleteRepair(_ repair: Repair) {
        CoreDataManaged.shared.deleteRepair(repair: repair)
    }
}
