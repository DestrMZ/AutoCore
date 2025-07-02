//
//  MainView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 11.10.2024.
//

import SwiftUI

struct MainView: View {
    
    @Namespace private var animationNamespace
    @EnvironmentObject var carViewModel: CarViewModel
    @EnvironmentObject var repairViewModel: RepairViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    @State private var selectedTab: CustomTapBar.TabItems = .cars
    @State private var showTapBar: Bool = true
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case .cars:
                CarProfileView(showTapBar: $showTapBar)
            case .repair:
                ListRepairView(showTapBar: $showTapBar)
            case .statistics:
                StatisticsView()
            case .settings:
                SettingsView()
            }
        }
        .overlay(
            VStack {
                Spacer()
                if showTapBar {
                    CustomTapBar(selectedTab: $selectedTab)
                        .matchedGeometryEffect(id: "tabbar", in: animationNamespace)
                        .padding(.bottom)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showTapBar) 
        )
        .edgesIgnoringSafeArea(.bottom)
    }
}


//#Preview {
//    MainView()
//        .environmentObject(CarViewModel())
//        .environmentObject(RepairViewModel())
//}
