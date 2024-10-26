//
//  MainView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 11.10.2024.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    @EnvironmentObject var repairViewModel: RepairViewModel
    
    var body: some View {
            TabView {
                
                SelectCarView()
                    .tabItem {
                        Image(systemName: "car.2")
                        Text("Cars")
                    }
                
                ListRepairView()
                    .tabItem {
                        Image(systemName: "wrench")
                        Text("Repairs")
                    }
                
                StatisticsView()
                    .tabItem {
                        Image(systemName: "chart.bar")
                        Text("Statistics")
                    }
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(CarViewModel())
        .environmentObject(RepairViewModel())
}
