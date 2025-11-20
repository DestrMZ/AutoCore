//
//  MockRepairRepository.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 17.07.2025.
//

import Foundation


final class MockRepairRepository: RepairRepositoryProtocol {
    
    var mockRepairs: [RepairModel] = []
    var shouldFail: Bool = false
    
    func createRepair(repairModel: RepairModel, for carID: UUID) throws -> RepairModel {
        if shouldFail {
            throw RepositoryError.fetchFailed
        }
        mockRepairs.append(repairModel)
        return repairModel
    }
    
    func fetchAllRepairs(for carID: UUID) throws -> [RepairModel] {
        if shouldFail {
            throw RepositoryError.fetchFailed
        }
        return mockRepairs
    }
    
    func updateRepair(repair: RepairModel, for carID: UUID) throws {
        if shouldFail {
            throw RepositoryError.updateFailed
        }
        guard let index = mockRepairs.firstIndex(where: { $0.id == repair.id }) else {
            throw RepositoryError.repairNotFound
        }
        mockRepairs[index] = repair
    }

    func deleteRepair(repair: RepairModel) throws {
        if shouldFail {
            throw RepositoryError.deleteFailed
        }
        guard let index = mockRepairs.firstIndex(where: { $0.id == repair.id }) else {
            throw RepositoryError.repairNotFound
        }
        mockRepairs.remove(at: index)
    }
}
