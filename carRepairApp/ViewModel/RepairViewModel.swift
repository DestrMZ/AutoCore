//
//  RepairViewModel.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import Foundation
import PhotosUI


class RepairViewModel: ObservableObject {
    
    var db = CoreDataManaged.shared
    
    @Published var repairDate = Date()
    @Published var partReplaced = ""
    @Published var amount: Int32 = 0
    @Published var repairMileage: Int32 = 0
    @Published var notes: String = ""
    @Published var photoRepair: Data = Data()
    @Published var car: Car? = nil
    
    @Published var repairArray: [Repair] = []
    
    func loadCar() {
        if let loadedCar = db.fetchFirstCar() {
            self.car = loadedCar
            print("Car loaded: \(String(describing: loadedCar.nameModel)) -> (RepairViewModel)")
        } else {
            print("Car not found -> (RepairViewModel)")
        }
    }
    
    func createNewRepair(for: Car) {
        if let car = self.car {
            db.creatingRepair(
                repairDate: self.repairDate,
                partReplaced: self.partReplaced,
                amount: self.amount,
                repairMileage: self.repairMileage,
                notes: self.notes,
                photoRepair: self.photoRepair,
                car: car)
            db.saveContent()
            
            getAllRepair(for: car)

            print("Repair successfully created, car: \(String(describing: car.nameModel)) -> (RepairViewModel)")
        } else {
            print("Car not found -> (RepairViewModel)")
        }
    }
    
    func getAllRepair(for car: Car) {
        let requstAllRepair = db.fetchAllRepair(for: car)
        self.repairArray = requstAllRepair
    }
    
    func getPhotoRepair(repair: Repair) -> UIImage? {
        let image = db.fetchImageRepairCoreData(repair: repair)
        return image
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
        print("Repair successfully deleted -> (RepairViewModel)")
    }
    
}
