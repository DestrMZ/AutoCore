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
    
    @State private var selectedTab: CustomTapBar.TabItems = .cars
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case .cars:
                SelectCarView()
            case .repair:
                ListRepairView()
            case .statistics:
                StatisticsView()
            case .settings:
                SettingsView()
            }

            VStack {
                Spacer()
                
                CustomTapBar(selectedTab: $selectedTab)
                    .padding(.bottom)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}


#Preview {
    MainView()
        .environmentObject(CarViewModel())
        .environmentObject(RepairViewModel())
}
