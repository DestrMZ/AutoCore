//
//  MainView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 11.10.2024.
//

import SwiftUI

struct MainView: View {
    
    let carStore: CarStore
    let repairStore: RepairStore
    let insuranceStore: InsuranceStore
    
    @Namespace private var animationNamespace
    
    @State private var selectedTab: CustomTapBar.TabItems = .cars
    @State private var showTapBar: Bool = true
    
    init(carStore: CarStore, repairStore: RepairStore, insuranceStore: InsuranceStore) {
        self.carStore = carStore
        self.repairStore = repairStore
        self.insuranceStore = insuranceStore
    }
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case .cars:
                CarProfileView(carStore: carStore, repairStore: repairStore, insuranceStore: insuranceStore,showTapBar: $showTapBar)
            case .repair:
                ListRepairView(carStore: carStore, repairStore: repairStore, showTapBar: $showTapBar)
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
