//
//  AddCarViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 01.08.2025.
//

import Foundation


class AddCarViewModel: ObservableObject {
    
    private let carUseCase: CarUseCaseProtocol
    private let sharedCarStore: SharedCarStore
    
    init(carUseCase: CarUseCaseProtocol, sharedCarStore:SharedCarStore) {
        self.carUseCase = carUseCase
        self.sharedCarStore = sharedCarStore
    }
    
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
    
    
    func addCar(newCar: CarModel) {
        do {
            let result = try carUseCase.createCar(carModel: newCar)
            self.sharedCarStore.addCar(result)
            self.sharedCarStore.selectCar(result)
        } catch let error as CarError {
            alertMessage = error.localizedDescription
            isShowAlert = true
        } catch {
            alertMessage = error.localizedDescription
            isShowAlert = true
        }
    }
    
}
