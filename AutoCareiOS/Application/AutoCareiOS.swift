//
//  carRepairAppApp.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//С

import SwiftUI

@main
struct AutoCareiOS: App {
    
    static let factory = AppFactory.shared
    
    @StateObject private var carStore: CarStore
    @StateObject private var repairStore: RepairStore
    @StateObject private var insuranceStore: InsuranceStore
    
    init() {
        _carStore = StateObject(wrappedValue: CarStore(carUseCase: Self.factory.carUseCase))
        _repairStore = StateObject(wrappedValue: RepairStore(repairUseCase: Self.factory.repairUseCase))
        _insuranceStore = StateObject(wrappedValue: InsuranceStore(insuranceUseCase: Self.factory.insuranceUseCase))
    }
                                                        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(carStore)
                .environmentObject(repairStore)
                .environmentObject(insuranceStore)
                .environmentObject(Self.factory.settingsViewModel)
                .preferredColorScheme(Self.factory.settingsViewModel.changeColorScheme())
        }
    }
}
