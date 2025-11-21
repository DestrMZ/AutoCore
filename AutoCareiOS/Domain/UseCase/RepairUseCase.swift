//
//  RepairUseCase.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 23.06.2025.
//

import Foundation


final class RepairUseCase: RepairUseCaseProtocol {

    private let repairRepository: RepairRepositoryProtocol

    init(repairRepository: RepairRepositoryProtocol) {
        self.repairRepository = repairRepository
    }

    func createRepair(for carModel: CarModel, repairModel: RepairModel) throws -> RepairModel {
        try validateRepair(repairModel: repairModel)

        do {
            let repair = try repairRepository.createRepair(repairModel: repairModel, for: carModel.id)
            debugPrint("[RepairUseCase] \(repairModel.partReplaced) successful created!")
            return repair
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

    func fetchRepairsGroupByMonth(for repairs: [RepairModel]) throws -> [RepairGroup] {
        var result: [String: [RepairModel]] = [:]

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "LLLL yyyy"

        for repair in repairs {
            let date = repair.repairDate

            let month = formatter.string(from: date)
            let key = month.prefix(1).capitalized + month.dropFirst()

            if result[key] != nil {
                result[key]?.append(repair)
            } else {
                result[key] = [repair]
            }
        }

        let sortedResult = result.sorted { (lhs, rhs) in
            formatter.date(from: lhs.key)! > formatter.date(from: rhs.key)!
        }

        return sortedResult.map { (month, repairsInMonth) in
            let totalAmount = repairsInMonth.reduce(0) { $0 + Double($1.amount )}
            return RepairGroup(monthTitle: month, repairs: repairsInMonth, totalAmount: totalAmount)}
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
            throw RepairError.invalidLitresFuelFormat
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
    func createRepair(for carModel: CarModel, repairModel: RepairModel) throws -> RepairModel

    func fetchAllRepairs(for carModel: CarModel) throws -> [RepairModel]

    func updateRepair(repairModel: RepairModel, for carModel: CarModel) throws

    func fetchRepairsGroupByMonth(for repairs: [RepairModel]) throws -> [RepairGroup]

    func deleteRepair(repairModel: RepairModel) throws

    func validateRepair(repairModel: RepairModel) throws
}
