//
//  DashboardViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 18.11.2025.
//

import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {
    
    private let carStore: CarStore
    private let repairStore: RepairStore
    
    // MARK: SSOT
    @Published private(set) var cars: [CarModel] = []
    @Published private(set) var selectedCar: CarModel? = nil
    
    @Published private(set) var lastRefuelLiters: String = "—"
    @Published private(set) var lastRefuelAgo: String = "No"
    
    @Published private(set) var currentMileage: Int32 = 0
    
    @Published var alertMessage: String = ""
    @Published var isShowAlert: Bool = false
    @Published var didSaveSuccessfully: Bool = false
        
    var nameModel: String { selectedCar?.nameModel ?? "" }
    var year: Int16 { selectedCar?.year ?? 0 }
    var vinNumber: String { selectedCar?.vinNumbers ?? "" }
    var color: String? { selectedCar?.color }
    var engineType: EngineTypeEnum { EngineTypeEnum(rawValue: selectedCar?.engineType ?? "") ?? .gasoline }
    var transmissionType: TransmissionTypeEnum { TransmissionTypeEnum(rawValue: selectedCar?.transmissionType ?? "") ?? .automatic }
    var photoCar: Data { selectedCar?.photoCar ?? Data() }
    var stateNumber: String { selectedCar?.stateNumber ?? "" }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(carStore: CarStore, repairStore: RepairStore) {
        self.carStore = carStore
        self.repairStore = repairStore
        
        carStore.$cars
            .receive(on: RunLoop.main)
            .sink { [weak self] newCars in
                self?.cars = newCars
            }
            .store(in: &cancellables)
        
        carStore.$selectedCar
            .receive(on: RunLoop.main)
            .sink { [weak self] newSelectedCar in
                self?.selectedCar = newSelectedCar
                self?.currentMileage = newSelectedCar?.mileage ?? 0
            }
            .store(in: &cancellables)
        
        repairStore.$repairs
        .combineLatest(carStore.$selectedCar)
        .receive(on: RunLoop.main)
        .sink { [weak self] repairs, selectedCar in
            self?.updateLastRefuel(from: repairs)
        }
        .store(in: &cancellables)
    }
    
    deinit {
        print("DashboardViewModel - is deinitialized")
    }
    
    // MARK: Methods for working vihicle
    func selectCar(carModel: CarModel) {
        self.carStore.selectCar(carModel)
    }
    
    func updateMileage(for car: CarModel, new mileage: Int32) {
        do {
            try carStore.updateMileage(for: car, newMileage: mileage)
        } catch {
            handleError(error)
        }
    }
    
    func deleteCar(car: CarModel) {
        do {
            try carStore.deleteCar(car)
        } catch {
            handleError(error)
        }
    }
    
    // MARK: Repair methods
    func updateLastRefuel(from repairs: [RepairModel]) {
        let refuels = repairs.filter { $0.repairCategory == "Fuel" }
        
        if let latest = refuels.max(by: { $0.repairDate < $1.repairDate }) {
            let liters = String(format: "%.1f", latest.litresFuel ?? 0)
            lastRefuelLiters = "\(liters) L"
            lastRefuelAgo = relativeDateString(from: latest.repairDate)
        } else {
            lastRefuelLiters = "—"
            lastRefuelAgo = "No"
        }
    }
    
    private func relativeDateString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.locale = Locale.current
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    // MARK: Matching errors
    private func handleError(_ error: Error) {
        alertMessage = error.localizedDescription
        isShowAlert = true
    }
}

