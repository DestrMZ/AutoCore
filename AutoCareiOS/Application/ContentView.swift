////
////  ContentView.swift
////  carRepairApp
////
////  Created by Ivan Maslennikov on 09.10.2024.
////


import SwiftUI


struct ContentView: View {
    
    @EnvironmentObject var carStore: CarStore
    @EnvironmentObject var repairStore: RepairStore
    @EnvironmentObject var insuranceStore: InsuranceStore
    
    var body: some View {
        VStack {
            MainView(
                carStore: carStore,
                repairStore: repairStore,
                insuranceStore: insuranceStore)
        }
    }
}


#Preview {
    ContentView()
}
