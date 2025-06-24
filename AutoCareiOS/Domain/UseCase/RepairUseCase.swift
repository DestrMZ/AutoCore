//
//  RepairUseCase.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 23.06.2025.
//

import Foundation


class RepairUseCase: RepairUseCaseProtocol {
    
    private let repairRepository: RepairRepositoryProtocol
    
    init(repairRepository: RepairRepositoryProtocol) {
        self.repairRepository = repairRepository
    }
    
    func createRepair(for carModel: CarModel, repairModel: RepairModel) throws {
        try validateRepair(repairModel: repairModel)
        
        do {
            try repairRepository.createRepair(repairModel: repairModel, for: carModel.id)
            debugPrint("[RepairUseCase] \(repairModel.partReplaced) successful created!")
        } catch RepositoryError.carNotFound {
            throw RepairError.carNotFound
        } catch RepositoryError.createFailed {
            throw RepairError.createFailed
        }
    }
    
    func fetchAllRepairs(for carModel: CarModel) throws -> [RepairModel] {
        do {
            return try repairRepository.fetchAllRepairs(for: carModel.id)
        } catch RepositoryError.fetchFailed {
            throw RepairError.fetchFailed
        }
    }
    
    func updateRepair(repairModel: RepairModel, for carModel: CarModel) throws {
        try validateRepair(repairModel: repairModel)
        
        do {
            try repairRepository.updateRepair(repair: repairModel, for: carModel.id)
            debugPrint("[RepairUseCase] \(repairModel.partReplaced) successful updated!")
        } catch RepositoryError.repairNotFound {
            throw RepairError.repairNotFound
        } catch RepositoryError.carNotFound {
            throw RepairError.carNotFound
        } catch RepositoryError.updateFailed {
            throw RepairError.updateFailed
        }
    }
    
    func fetchLatestRefueling(from repairs: [RepairModel]) -> (litres: String, date: Date) {
        let refuels = repairs.filter { $0.repairCategory == "Fuel" }
        
        guard let latest = refuels.max(by: { $0.repairDate < $1.repairDate }) else {
            return (litres: "0", date: Date())
        }

        let litres = String(format: "%.1f", latest.litresFuel ?? 0)
        return (litres: litres, date: latest.repairDate)
    }
    
    func deleteRepair(repairModel: RepairModel) throws {
        do {
            try repairRepository.deleteRepair(repair: repairModel)
            debugPrint( "[RepairUseCase] \(repairModel.partReplaced) successful deleted!")
        } catch RepositoryError.repairNotFound {
            throw RepairError.repairNotFound
        } catch RepositoryError.deleteFailed {
            throw RepairError.deleteFailed
        }
    }
    
    func validateRepair(repairModel: RepairModel) throws {
        if repairModel.partReplaced.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw RepairError.missingTitle
        }

        if repairModel.amount <= 0 {
            throw RepairError.missingAmount
        }

        if repairModel.repairMileage <= 0 {
            throw RepairError.missingMileage
        }

        if repairModel.repairMileage > 5_000_000 {
            throw RepairError.mileageExceedsLimit
        }

        if let litres = repairModel.litresFuel, litres < 0 {
            throw RepairError.invalidAmountFormat
        }

        if let photos = repairModel.photoRepairs, photos.count > 10 {
            throw RepairError.tooManyPhotos
        }

        for (key, value) in repairModel.parts {
            if key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
               value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                throw RepairError.invalidPartDescription
            }
        }
    }
}


protocol RepairUseCaseProtocol {
    func createRepair(for carModel: CarModel, repairModel: RepairModel) throws
    
    func fetchAllRepairs(for carModel: CarModel) throws -> [RepairModel]
    
    func updateRepair(repairModel: RepairModel, for carModel: CarModel) throws
    
    func fetchLatestRefueling(from repairs: [RepairModel]) -> (litres: String, date: Date)
    
    func deleteRepair(repairModel: RepairModel) throws
    
    func validateRepair(repairModel: RepairModel) throws
}
