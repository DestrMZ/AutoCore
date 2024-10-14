//
//  RepairViewModel.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import Foundation


class RepairViewModel: ObservableObject {
    
    private var db = CoreDataManaged.shared
    
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
        guard let car = self.car else{
            print("К сожалению, не указан автомобиль")
            return
        }
        
        db.creatingRepair(
            repairDate: self.repairDate,
            partReplaced: self.partReplaced,
            cost: self.cost,
            repairMileage: self.repairMileage,
            repairShop: self.repairShop,
            nextServiceDate: self.nextServiceDate,
            notes: self.notes,
            photoRepair: self.photoRepair,
            car: car
        
        )
        getAllRepair(for: car)
    }
    
    func getAllRepair(for car: Car) {
        let requstAllRepair = db.fetchAllRepair(for: car)
        self.repairArray = requstAllRepair
    }
    
    func deleteRepair(_ repair: Repair) {
        db.deleteRepair(repair: repair)
    }
}
