//
//  RepairViewModel.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import Foundation


class RepairViewModel: ObservableObject {
    
    var db = CoreDataManaged.shared
    
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
    
    func loadCar() {
        if let loadedCar = db.fetchCar() {
            self.car = loadedCar
            print("Car loaded: \(String(describing: loadedCar.nameModel))")
        } else {
            print("Car not found")
        }
    }
    
    func createNewRepair() {
        if let car = self.car {
            db.creatingRepair(
                repairDate: self.repairDate,
                partReplaced: self.partReplaced,
                cost: self.cost,
                repairMileage: self.repairMileage,
                repairShop: self.repairShop,
                nextServiceDate: self.nextServiceDate,
                notes: self.notes,
                photoRepair: self.photoRepair,
                car: car)
            db.saveContent()
            
            getAllRepair(for: car)

            print("Repair successfully created, car: \(String(describing: car.nameModel))")
        } else {
            print("Car not found")
        }
    }
    
    func getAllRepair(for car: Car) {
        let requstAllRepair = db.fetchAllRepair(for: car)
        self.repairArray = requstAllRepair
    }
    
    func deleteRepair(_ repair: Repair) {
        db.deleteRepair(repair: repair)
    }
    
    func deteteRepairFromList(at offset: IndexSet) {
        offset.forEach { index in
            let repair = self.repairArray[index]
            db.deleteRepair(repair: repair)
            self.repairArray.remove(at: index)
        }
        
        db.saveContent() 
        print("Repair successfully deleted")
    }
}
