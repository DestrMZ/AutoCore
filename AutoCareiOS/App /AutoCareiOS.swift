//
//  carRepairAppApp.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import SwiftUI

@main
struct AutoCareiOS: App {
    
    @StateObject var carViewModel: CarViewModel = CarViewModel()
    @StateObject var repairViewModel: RepairViewModel = RepairViewModel()
    @StateObject var settingsViewModel: SettingsViewModel = SettingsViewModel()
    @StateObject var phoneViewModel: PhoneSessionViewModel = PhoneSessionViewModel()


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(carViewModel)
                .environmentObject(repairViewModel)
                .environmentObject(settingsViewModel)
                .preferredColorScheme(settingsViewModel.changeColorScheme())
                .onAppear {
                    carViewModel.initializeCarRepairApp()
                    NotificationService.shared.requestNotificationPermission()
                }
        }
    }
}

