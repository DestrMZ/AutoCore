//
//  RepairViewModel.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import Foundation


class RepairViewModel: ObservableObject {
    
    private var repairService = RepairDataService()
    
    @Published var repairDate = Date()
    @Published var partReplaced = ""
    @Published var amount: Int32? = nil
    @Published var repairMileage: Int32? = nil
    @Published var notes: String = ""
    @Published var photoRepair: [Data] = [Data()]
    @Published var repairCategory: RepairCategory = .service
    @Published var parts: [Part] = []
    
    @Published var car: Car? = nil
    @Published var repairArray: [Repair] = []
    
    @Published var alertMessage: String = ""
    @Published var alertShow: Bool = false

    func createNewRepair(for car: Car?, partReplaced: String, amount: Int32, repairDate: Date?, repairMileage: Int32, notes: String, photoRepair: [Data], repairCategory: RepairCategory, partsDict: [String: String]) {
        guard let car = car else { return }
        
        alertShow = false
        
        let result = repairService.creatingRepair(
            repairDate: repairDate,
            partReplaced: partReplaced,
            amount: amount,
            repairMileage: repairMileage,
            notes: notes,
            photoRepair: photoRepair,
            repairCategory: repairCategory.rawValue,
            car: car,
            partsDict: partsDict)
        
        switch result {
        case .success():
            getAllRepairs(for: car)
        case .failure(let error):
            alertMessage = error.localizedDescription
            alertShow = true
        }
    }
    
    func editingRepair(for repair: Repair?, partReplaced: String, amount: Int32?, repairDate: Date?, repairMileage: Int32?, notes: String, photoRepair: [Data]?, repairCategory: RepairCategory, partsDict: [String: String]) {
        
        alertShow = false
        
        let result = repairService.updateRepair(
            for: repair,
            repairDate: repairDate,
            partReplaced: partReplaced,
            amount: amount,
            repairMileage: repairMileage,
            notes: notes,
            photoRepair: photoRepair,
            repairCategory: repairCategory.rawValue,
            partsDict: partsDict
        )
        
        switch result {
        case .success():
            alertMessage = "Repair updated successfully"
            
        case .failure(let error):
            alertMessage = error.localizedDescription
            alertShow = true
        }
    }
    
    func getAllRepairs(for car: Car) {
        self.repairArray = repairService.getAllRepairs(for: car)
    }
    
    func deleteRepair(_ repair: Repair) {
        if let index = repairArray.firstIndex(where: { $0.id == repair.id }) {
            repairArray.remove(at: index)
            repairService.deleteRepair(at: repair)
        } else {
            print("WARNING: Ошибка удаления ремонта!")
        }
    }
    
    // MARK: Method for work struct Part
    func addPart(for parts: inout [Part]) {
        parts.append(Part(article: "", name: ""))
    }
    
    func removePart(for parts: inout [Part], to index: Int) {
        parts.remove(at: index)
    }
    
    func savePart(parts: [Part]) -> [String: String] {
        PartMappers.toDictionary(self.parts)
    }
    
    func loadPart(from dictionary: [String: String]) {
        self.parts = PartMappers.fromDictionary(dictionary)
    }
    
}
