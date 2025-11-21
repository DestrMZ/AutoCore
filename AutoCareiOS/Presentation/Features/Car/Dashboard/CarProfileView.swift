//
//  MainCarView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 18.05.2025.
//

import SwiftUI
import TipKit


struct CarProfileView: View {
    
    private let carStore: CarStore
    private let repairStore: RepairStore
    private let insuranceStore: InsuranceStore
    
    @StateObject var dashboardViewModel: DashboardViewModel
    
    @Environment(\.dismiss) private var dismiss

    @State var isSelecting: Bool = false
    @State var showQuestionMark: Bool = false
    
    @Binding var showTapBar: Bool
    
    init(carStore: CarStore, repairStore: RepairStore, insuranceStore: InsuranceStore, showTapBar: Binding<Bool>) {
        self.carStore = carStore
        self.repairStore = repairStore
        self._dashboardViewModel = StateObject(wrappedValue: DashboardViewModel(carStore: carStore, repairStore: repairStore))
        self.insuranceStore = insuranceStore
        _showTapBar = showTapBar
    }
   
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                CarAvatarView(image: UIImage(data: dashboardViewModel.photoCar))
                
                ScrollView {
                    VStack {
                        Spacer().frame(height: 250)
                        Text("\(dashboardViewModel.nameModel)")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                            .shadow(radius: 4)
                        
                        Button(action: {
                            copyToClipboard(text: dashboardViewModel.stateNumber)
                            provideHapticFeedbackHeavy()
                            
                        }) {
                            LicensePlateView(stateNumber: dashboardViewModel.stateNumber)
                        }
                        
                        HStack(spacing: 16) {
                            Label(String(dashboardViewModel.year), systemImage: "calendar")
                            
                            Button(action: {
                                copyToClipboard(text: dashboardViewModel.vinNumber)
                                provideHapticFeedbackHeavy()
                            }) {
                                Label("VIN: \(dashboardViewModel.vinNumber)", systemImage: "doc.text.magnifyingglass")
                            }
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding()
                    }
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            MileageCardView(dashboardViewModel: dashboardViewModel)
                            RefuelCardView(dashboardViewModel: dashboardViewModel)
                        }
                        
                        WebViewScreen()
                        
                        if let selectedCar = dashboardViewModel.selectedCar {
                            InsuranceListSelection(insuranceStore: insuranceStore, selectedCar: selectedCar)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        HStack {
                            Text("Предстоящее ТО")
                                .font(.title3)
                                .bold()
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        ServiceCardView()
                    }
                }
                .padding(.bottom, 80)
                
                if isSelecting {
                    CarSelectionCarouselView(carStore: carStore, dashboardViewModel: dashboardViewModel, isSelecting: $isSelecting)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .zIndex(1)
                        .onAppear {
                            showTapBar = false
                        }
                        .onDisappear {
                            showTapBar = true
                        }
                    
                    Color.black.opacity(0.4)
                        .background(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation {
                                isSelecting = false
                            }
                        }
                }
            }
            .ignoresSafeArea(edges: .top)
            .onLongPressGesture(minimumDuration: 0.6) {
                withAnimation {
                    isSelecting = true
                }
            }
            .animation(.easeInOut(duration: 0.4), value: isSelecting)
        }
    }
}

#Preview {
    let carStore = CarStore(carUseCase: CarUseCase(
        carRepository: MockCarRepository(),
        userStoreRepository: UserStoreRepository()
    ))
    let insuranceStore = InsuranceStore(insuranceUseCase: InsuranceUseCase(
        insuranceRepository: MockInsuranceRepository()
    ))
    
    let repairStore = RepairStore(repairUseCase: RepairUseCase(repairRepository: MockRepairRepository()
    ))
                                                              

    return CarProfileView(
        carStore: carStore,
        repairStore: repairStore,
        insuranceStore: insuranceStore,
        showTapBar: .constant(true)
    )
}




