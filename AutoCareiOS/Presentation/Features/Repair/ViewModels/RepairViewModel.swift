//
//  RepairViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 26.06.2025.
//

import Foundation


class RepairViewModel: ObservableObject {
    
    private let repairUseCase: RepairUseCaseProtocol
    
    init(repairUseCase: RepairUseCaseProtocol) {
        self.repairUseCase = repairUseCase
    }
    
    @Published var nameRepair: String = ""
    @Published var repairDate: Date = Date()
    @Published var amount: Int32 = 0
    @Published var mileage: Int32 = 0
    @Published var notes: String? = nil
    @Published var photoRepair: [Data] = []
    @Published var category: RepairCategory = .service
    @Published var parts: [Part] = []
    @Published var litresFuel: String = ""
    
    @Published var repairs: [RepairModel] = []
    
    @Published var alertMessage: String = ""
    @Published var alertShow: Bool = false
    
    func addRepair(for car: CarModel, repairModel: RepairModel) {
        do {
            let repair = try repairUseCase.createRepair(for: car, repairModel: repairModel)
            self.repairs.append(repair)
        } catch {
            alertMessage = "\(error.localizedDescription)"
            alertShow = true
        }
    }
    
    func updateRepair(for car: CarModel, repairModel: RepairModel) {
        do {
            try repairUseCase.updateRepair(repairModel: repairModel, for: car)
        } catch {
            alertMessage = "\(error.localizedDescription)"
            alertShow = true
        }
    }
    
    func fetchAllRepairs(for car: CarModel) {
        do {
            self.repairs = try repairUseCase.fetchAllRepairs(for: car)
        } catch {
            alertMessage = "\(error.localizedDescription)"
        }
    }
    
    func getLastRefuel(repairs: [RepairModel]) -> (litres: String, date: Date) {
        do {
            return try repairUseCase.fetchLatestRefueling(from: repairs)
        } catch {
            alertMessage = "\(error.localizedDescription)"
            return (litres: "None", date: Date())
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
            if let index = repairs.firstIndex(of: repair) {
                repairs.remove(at: index)
            }
        } catch {
            alertMessage = "\(error.localizedDescription)"
            alertShow = true
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
