//
//  MockRepairUseCase.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 20.11.2025.
//

import Foundation
@testable import AutoCareiOS


final class RepairUseCaseMock: RepairUseCaseProtocol {
    
    var repairs: [RepairModel]
    var error: Error?

    init(repairs: [RepairModel]) {
        self.repairs = repairs
    }

    func createRepair(for car: CarModel, repairModel: RepairModel) throws -> RepairModel {
        if let error { throw error }
        repairs.append(repairModel)
        return repairModel
    }

    func updateRepair(repairModel: RepairModel, for car: CarModel) throws {
        if let error { throw error }
        guard let index = repairs.firstIndex(where: { $0.id == repairModel.id }) else { return }
        repairs[index] = repairModel
    }

    func fetchAllRepairs(for car: CarModel) throws -> [RepairModel] {
        if let error { throw error }
        return repairs
    }

    func deleteRepair(repairModel: RepairModel) throws {
        if let error { throw error }
        repairs.removeAll(where: { $0.id == repairModel.id })
    }

    func fetchLatestRefueling(from repairs: [RepairModel]) throws -> (litres: String, date: Date) {
        if let error { throw error }
        guard let refuel = repairs.first(where: { $0.litresFuel != nil }) else {
            throw NSError(domain: "NoRefuel", code: 0)
        }
        return (String(refuel.litresFuel ?? 0), refuel.repairDate)
    }

    func fetchRepairsGroupByMonth(for repairs: [RepairModel]) throws -> [RepairGroup] {
        let repair = RepairModel.mock()
        let group = RepairGroup(monthTitle: "Ноябрь 2025", repairs: [repair], totalAmount: 15000)
        return [group]
    }
    
    func validateRepair(repairModel: RepairModel) throws {
        //
    }
}
