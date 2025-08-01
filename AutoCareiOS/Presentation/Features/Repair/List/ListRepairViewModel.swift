//
//  ListViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 31.07.2025.
//

import Foundation


class ListRepairViewModel: ObservableObject {
    
    private let repairUseCase: RepairUseCaseProtocol
    private var sharedRepairStore: SharedRepairStoreProtocol
    
    @Published var alertMessage: String?
    @Published var alertShow: Bool = false
    
    init(repairUseCase: RepairUseCaseProtocol, sharedRepairStore: SharedRepairStoreProtocol) {
        self.repairUseCase = repairUseCase
        self.sharedRepairStore = sharedRepairStore
    }
    
    func fetchAllRepairs(for car: CarModel) {
        do {
            self.sharedRepairStore.repairs = try repairUseCase.fetchAllRepairs(for: car)
        } catch {
            alertMessage = "\(error.localizedDescription)"
            alertShow = true
        }
    }
    
    func fetchRepairsGroupByMonth(for repairs: [RepairModel]) -> [RepairGroup] {
        do {
            return try repairUseCase.fetchRepairsGroupByMonth(for: repairs)
        } catch {
            alertMessage = "\(error.localizedDescription)"
            return []
        }
    }
    
    func deleteRepair(repair: RepairModel) {
        do {
            try repairUseCase.deleteRepair(repairModel: repair)
            if let index = self.sharedRepairStore.repairs.firstIndex(of: repair) {
                self.sharedRepairStore.repairs.remove(at: index)
            }
        } catch {
            alertMessage = "\(error.localizedDescription)"
            alertShow = true
        }
    }
}
