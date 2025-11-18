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
    
    // MARK: SSOT
    @Published private(set) var cars: [CarModel] = []
    @Published private(set) var selectedCar: CarModel? = nil
    
    // MARK: Selected car
    @Published var nameModel: String = ""
    @Published var year: Int16 = 0
    @Published var vinNumber: String = ""
    @Published var color: String? = nil
    @Published var mileage: Int32 = 0
    @Published var engineType: EngineTypeEnum = .gasoline
    @Published var transmissionType: TransmissionTypeEnum = .automatic
    @Published var photoCar: Data = Data()
    @Published var stateNumber: String = ""
    
    @Published var alertMessage: String = ""
    @Published var isShowAlert: Bool = false
    @Published var didSaveSuccessfully: Bool = false
    
    init(carStore: CarStore) {
        self.carStore = carStore
        
        carStore.$cars
            .receive(on: RunLoop.main)
            .assign(to: &$cars)
        
        carStore.$selectedCar
            .receive(on: RunLoop.main)
            .assign(to: &$selectedCar)
    }

    func populate(from carModel: CarModel) {
        self.nameModel = carModel.nameModel
        self.year = carModel.year
        self.vinNumber = carModel.vinNumbers
        self.color = carModel.color
        self.mileage = carModel.mileage
        self.engineType = EngineTypeEnum(rawValue: carModel.engineType) ?? .gasoline
        self.transmissionType = TransmissionTypeEnum(rawValue: carModel.transmissionType) ?? .manual
        self.photoCar = carModel.photoCar! as Data
        self.stateNumber = carModel.stateNumber ?? ""
    }
    
    func selectCar(carModel: CarModel) {
        self.carStore.selectCar(carModel)
    }
    
}

