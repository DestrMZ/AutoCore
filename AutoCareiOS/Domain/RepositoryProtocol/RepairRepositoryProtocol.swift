//
//  RepairRepositoryProtocol.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 29.06.2025.
//

import Foundation


protocol RepairRepositoryProtocol {
    func createRepair(repairModel: RepairModel, for carID: UUID) throws -> RepairModel
    
    func fetchAllRepairs(for carID: UUID) throws -> [RepairModel]
    
    func updateRepair(repair: RepairModel, for carID: UUID) throws
    
    func deleteRepair(repair: RepairModel) throws
}
