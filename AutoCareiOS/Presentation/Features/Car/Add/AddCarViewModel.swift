//
//  AddCarViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 16.11.2025.
//

import Foundation


@MainActor
final class AddCarViewModel: ObservableObject {
    
    private let carStore: CarStore
    
    @Published var nameModel: String = ""
    @Published var yearText: String = ""
    @Published var vinNumber: String = ""
    @Published var color: String = ""
    @Published var mileageText: String = ""
    @Published var engineType: EngineTypeEnum = .gasoline
    @Published var transmissionType: TransmissionTypeEnum = .automatic
    @Published var stateNumber: String = ""
    
    @Published var photoData: Data = Data()
    
    @Published var alertMessage: String = ""
    @Published var isShowAlert: Bool = false
    @Published var didSaveSuccessfully: Bool = false
    
    init(carStore: CarStore) {
        self.carStore = carStore
    }
    
    func saveCar() {
        guard !nameModel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(text: "Car name is required")
            return
        }
        
        let newCar = self.toCarModel()
        
        do {
            try carStore.addCar(car: newCar)
            didSaveSuccessfully = true
        } catch let error as CarError{
            showAlert(text: error.localizedDescription)
        } catch {
            showAlert(text: error.localizedDescription)
        }
    }
    
    private func toCarModel() -> CarModel {
        let yearValue = Int16(yearText) ?? 0
        let mileageValue = Int32(mileageText) ?? 0
        
        return CarModel(
            id: UUID(),
            nameModel: nameModel,
            year: yearValue,
            color: color,
            engineType: engineType.rawValue,
            transmissionType: transmissionType.rawValue,
            mileage: mileageValue,
            photoCar: photoData,
            vinNumbers: vinNumber,
            stateNumber: stateNumber
        )
    }
    
    private func showAlert(text: String) {
        self.alertMessage = text
        isShowAlert = true
    }
}
