//
//  RepairListViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 24.11.2025.
//

import Foundation
import Combine

@MainActor
final class RepairListViewModel: ObservableObject {

    private let carStore: CarStore
    private let repairStore: RepairStore
    
    @Published private(set) var selectedCar: CarModel?

    @Published private(set) var repairs: [RepairModel] = []
    @Published private(set) var groupedRepairs: [RepairGroup] = []
    
    @Published var isLoading = false
    @Published var alertMessage: String?
    @Published var isShowAlert: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init(carStore: CarStore, repairStore: RepairStore) {
        self.carStore = carStore
        self.repairStore = repairStore
        
        carStore.$selectedCar
            .compactMap { $0 }
            .removeDuplicates(by: { $0.id == $1.id })
            .receive(on: RunLoop.main)
            .sink { [weak self] car in
                self?.selectedCar = car
                self?.loadRepairs(for: car)
            }
            .store(in: &cancellables)

        repairStore.$repairs
            .receive(on: RunLoop.main)
            .sink { [weak self] newRepairs in
                self?.repairs = newRepairs
                self?.updateGroupedRepairs()
            }
            .store(in: &cancellables)
    }

    func loadRepairs(for car: CarModel) {
        isLoading = true
        alertMessage = nil

        do {
            try repairStore.loadRepairs(for: car)
        } catch {
            handleError(error)
        }
        isLoading = false
    }

    func addRepair(_ repair: RepairModel, for car: CarModel) {
        do {
            try repairStore.addRepair(for: car, repairModel: repair)
        } catch {
            handleError(error)
        }
    }

    func updateRepair(_ repair: RepairModel, for car: CarModel) {
        do {
            try repairStore.updateRepair(for: car, repairModel: repair)
        } catch {
            handleError(error)
        }
    }

    func deleteRepair(_ repair: RepairModel) {
        do {
            try repairStore.deleteRepair(repair)
        } catch {
            handleError(error)
        }
    }

    private func updateGroupedRepairs() {
        do {
            groupedRepairs = try repairStore.repairsGroupedByMonth()
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        alertMessage = error.localizedDescription
        isShowAlert = true
    }
}
