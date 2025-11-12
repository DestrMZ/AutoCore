//
//  carRepairAppApp.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//С

import SwiftUI

@main
struct AutoCareiOS: App {
    
    let container = AppDIContainer.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(container.carViewModel)
                .environmentObject(container.repairViewModel)
                .environmentObject(container.insuranceViewModel)
                .environmentObject(container.settingsViewModel)
                .preferredColorScheme(container.settingsViewModel.changeColorScheme())
        }
    }
}
