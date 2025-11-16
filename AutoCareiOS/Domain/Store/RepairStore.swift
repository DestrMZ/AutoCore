//
//  RepairStore.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 16.11.2025.
//

import Foundation


@MainActor
final class RepairStore: ObservableObject {
    
    private let repairUseCase: RepairUseCaseProtocol
    
    @Published private(set) var repairs: [RepairModel] = []
    
    init(repairUseCase: RepairUseCaseProtocol) {
        self.repairUseCase = repairUseCase
    }
    
    func loadRepairs(for car: CarModel) throws {
        let fetchedRepairs = try repairUseCase.fetchAllRepairs(for: car)
        self.repairs = fetchedRepairs
    }
    
    func addRepair(for car: CarModel, repairModel: RepairModel) throws {
        let newRepair = try repairUseCase.createRepair(for: car, repairModel: repairModel)
        self.repairs.append(newRepair)
    }
    
    func updateRepair(for car: CarModel, repairModel: RepairModel) throws {
        try repairUseCase.updateRepair(repairModel: repairModel, for: car)
        
        if let index = repairs.firstIndex(where: { $0.id == repairModel.id }) {
            repairs[index] = repairModel
        }
    }
    
    func deleteRepair(_ repair: RepairModel) throws {
        try repairUseCase.deleteRepair(repairModel: repair)
        if let index = repairs.firstIndex(of: repair) {
            repairs.remove(at: index)
        }
    }
    
    func getLastRefuel() throws -> (litres: String, date: Date) {
        try repairUseCase.fetchLatestRefueling(from: repairs)
    }
    
    func repairsGroupedByMonth() throws -> [RepairGroup] {
        try repairUseCase.fetchRepairsGroupByMonth(for: repairs)
    }
}
