//
//  carRepairAppApp.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import SwiftUI

@main
struct carRepairAppApp: App {
    
    @StateObject var carViewModel: CarViewModel = CarViewModel()
    @StateObject var repairViewModel: RepairViewModel = RepairViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(carViewModel)
                .environmentObject(repairViewModel)
                .onAppear {
                    carViewModel.getAllCars()
                    DispatchQueue.main.async {
                        carViewModel.loadLastSelectCar()

                }
            }
        }
    }
}
