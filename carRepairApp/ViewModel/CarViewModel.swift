//
//  ManagerViewModel.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import Foundation


class CarViewModel: ObservableObject {
    
    @Published var nameModel: String = ""
    @Published var year: Int16 = 0
    @Published var vinNumber: String = ""
    @Published var color: String = ""
    @Published var mileage: Int32 = 0
    @Published var dateOfPurchase = Date()
    @Published var engineType: String = ""
    @Published var transmissionType: String = ""
    
    
    
    
    func createNewCar() {
        
        CoreDataManaged.shared.creatingCar(
            nameModel: self.nameModel,
            year: self.year,
            vinNumber: self.vinNumber,
            color: self.color,
            mileage: self.mileage,
            dateOfPurchase: self.dateOfPurchase,
            engineType: self.engineType,
            transmissionType: self.transmissionType)
        
        CoreDataManaged.shared.saveContent()
        
    }
    
    func getCar() -> Car? {
        let requestCar = CoreDataManaged.shared.fetchCar()
        return requestCar
    }
    
    func deleteCar() {
        // TODO: Writing function
    }
}
