//
//  AddViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 29.07.2025.
//

import Foundation


class AddRepairViewModel: ObservableObject {
    
    private let repairUseCase: RepairUseCaseProtocol
    
    init(repairUseCase: RepairUseCaseProtocol) {
        self.repairUseCase = repairUseCase
    }
    
    @Published var nameRepair: String = ""
    @Published var dateRepair: Date = Date()
    @Published var amountRepair: String = ""
    @Published var mileageRepair: String = ""
    @Published var notesRepiar: String = ""
    @Published var photoRepair: [Data] = []
    @Published var categoryRepair: RepairCategory = .service
    @Published var partsRepair: [Part] = [Part(article: "", name: "")]
    @Published var litresRepair: String = ""
    
    @Published var alertMessage: String = ""
    @Published var alertShow: Bool = false
    
//    var repairs: [RepairModel] {
//        sharedRepairStore.repairs
//    }
    
    func addRepair(for car: CarModel) {
        guard let repairModel = toRepairModel() else {
            return
        }
        
        do {
            let repair = try repairUseCase.createRepair(for: car, repairModel: repairModel)
//            sharedRepairStore.repairs.append(repair)
        } catch {
            alertMessage = error.localizedDescription
            alertShow = true
        }
    }
    
    func toRepairModel() -> RepairModel? {
        let trimmedName = nameRepair.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedName.isEmpty else {
                alertMessage = "Repair name cannot be empty."
                alertShow = true
                return nil
            }
        
        guard let parsedAmount = Int32(amountRepair) else {
            alertMessage = "Amount must be a valid number."
            alertShow = true
            return nil
        }
        
        guard let parsedMileage = Int32(mileageRepair) else {
                alertMessage = "Mileage must be a valid number."
                alertShow = true
                return nil
            }
        
        var parsedLitres: Double? = nil
        if categoryRepair == .fuel {
            let trimmedLitres = litresRepair.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedLitres.isEmpty {
                if let litres = Double(trimmedLitres) {
                    parsedLitres = litres
                } else {
                    alertMessage = "Litres must be a valid decimal number."
                    alertShow = true
                    return nil
                }
            } else {
                alertMessage = "Please enter litres of fuel."
                alertShow = true
                return nil
            }
        }
        
        return RepairModel(
            id: UUID(),
            amount: parsedAmount,
            litresFuel: parsedLitres,
            notes: notesRepiar,
            partReplaced: nameRepair,
            parts: savePart(parts: partsRepair),
            photoRepairs: photoRepair,
            repairCategory: categoryRepair.rawValue,
            repairDate: dateRepair,
            repairMileage: parsedMileage
        )
    }
    
    // MARK: Method for work struct Part
    func addPart(for parts: inout [Part]) {
        parts.append(Part(article: "", name: ""))
    }
    
    func removePart(for parts: inout [Part], to index: Int) {
        parts.remove(at: index)
    }
    
    func savePart(parts: [Part]) -> [String: String] {
        PartMappers.toDictionary(self.partsRepair)
    }
    
    func loadPart(from dictionary: [String: String]) {
        self.partsRepair = PartMappers.fromDictionary(dictionary)
    }
    
}
