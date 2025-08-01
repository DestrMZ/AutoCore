//
//  AppContainer.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 29.06.2025.
//

import Foundation


final class AppDIContainer {
    static let shared = AppDIContainer()
    
    // Repository
    let carRepository = CarRepository()
    let repairRepository = RepairRepository()
    let insuranceRepository = InsuranceRepository()
    let userStoreRepository = UserStoreRepository()
    
    // Shared-data
    let sharedRepair = SharedRepairStore()
    let sharedCar = SharedCarStore()
    let sharedInsurance = SharedInsuranceStore()
    
    // UseCase
    lazy var carUseCase = CarUseCase(carRepository: carRepository, userStoreRepository: userStoreRepository)
    lazy var repairUseCase = RepairUseCase(repairRepository: repairRepository)
    lazy var insuranceUseCase = InsuranceUseCase(insuranceRepository: insuranceRepository)
}
