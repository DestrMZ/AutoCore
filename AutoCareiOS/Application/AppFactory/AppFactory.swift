//
//  AppContainer.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 29.06.2025.
//

import Foundation


final class AppFactory {
    static let shared = AppFactory()
    
    // MARK: Repository
    let carRepository = CarRepository()
    let repairRepository = RepairRepository()
    let insuranceRepository = InsuranceRepository()
    let userStoreRepository = UserStoreRepository()
    
    // MARK: UseCase
    lazy var carUseCase: CarUseCase = CarUseCase(carRepository: carRepository, userStoreRepository: userStoreRepository)
    lazy var repairUseCase: RepairUseCase = RepairUseCase(repairRepository: repairRepository)
    lazy var insuranceUseCase: InsuranceUseCase = InsuranceUseCase(insuranceRepository: insuranceRepository)
    
    // MARK: Global ViewModel
    lazy var settingsViewModel = SettingsViewModel()
}


