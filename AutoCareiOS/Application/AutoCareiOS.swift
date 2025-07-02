//
//  carRepairAppApp.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//С

import SwiftUI

@main
struct AutoCareiOS: App {
    let container = AppDIContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(container.carViewModel)
                .environmentObject(container.repairViewModel)
                .environmentObject(container.insuranceViewModel)
            #warning("Fix this later")
//                .preferredColorScheme(settingsViewModel.changeColorScheme())
//                .onAppear {
//                    carViewModel.initializeCarRepairApp()
//                    NotificationService.shared.requestNotificationPermission()
//                }
        }
    }
}

