//
//  DashboardViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 18.11.2025.
//

import Foundation
import Combine

@MainActor
final class CarProfileViewModel: ObservableObject {
    
    private let carStore: CarStore
    
    // MARK: SSOT
    @Published private(set) var cars: [CarModel] = []
    @Published private(set) var selectedCar: CarModel? = nil
    
    @Published var alertMessage: String = ""
    @Published var isShowAlert: Bool = false
    @Published var didSaveSuccessfully: Bool = false
        
    var nameModel: String { selectedCar?.nameModel ?? "" }
    var year: Int16 { selectedCar?.year ?? 0 }
    var vinNumber: String { selectedCar?.vinNumbers ?? "" }
    var color: String? { selectedCar?.color }
    var mileage: Int32 { selectedCar?.mileage ?? 0 }
    var engineType: EngineTypeEnum { EngineTypeEnum(rawValue: selectedCar?.engineType ?? "") ?? .gasoline }
    var transmissionType: TransmissionTypeEnum { TransmissionTypeEnum(rawValue: selectedCar?.transmissionType ?? "") ?? .automatic }
    var photoCar: Data { selectedCar?.photoCar ?? Data() }
    var stateNumber: String { selectedCar?.stateNumber ?? "" }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(carStore: CarStore) {
        self.carStore = carStore
        
        carStore.$cars
            .receive(on: RunLoop.main)
            .sink { [weak self] newCars in
                self?.cars = newCars
            }
            .store(in: &cancellables)
        
        carStore.$selectedCar
            .receive(on: RunLoop.main)
            .sink { [weak self] newSelectedCar in
                self?.selectedCar = newSelectedCar}
            .store(in: &cancellables)
    }
    
    func selectCar(carModel: CarModel) {
        self.carStore.selectCar(carModel)
    }
    
    func deleteCar(car: CarModel) {
        do {
            try carStore.deleteCar(car)
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        alertMessage = error.localizedDescription
        isShowAlert = true
    }
}

