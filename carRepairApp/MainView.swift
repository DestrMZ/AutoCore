//
//  MainView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 11.10.2024.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    
    var body: some View {
        
        NavigationStack {
            
            TabView {
                            
                DashboardView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Main")
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
}

#Preview {
    MainView()
        .environmentObject(CarViewModel())
}
