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
    private let insuranceStore: InsuranceStore
    
    @StateObject var vm: CarProfileViewModel
    
    @Environment(\.dismiss) private var dismiss

    @State var isSelecting: Bool = false
    @State var showQuestionMark: Bool = false
    
    @Binding var showTapBar: Bool
    
    init(carStore: CarStore, insuranceStore: InsuranceStore, showTapBar: Binding<Bool>) {
        self.carStore = carStore
        self._vm = StateObject(wrappedValue: CarProfileViewModel(carStore: carStore))
        self.insuranceStore = insuranceStore
        _showTapBar = showTapBar
    }
   
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                CarAvatarView(image: UIImage(data: vm.photoCar))
                
                ScrollView {
                    VStack {
                        Spacer().frame(height: 250)
                        Text("\(vm.nameModel)")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                            .shadow(radius: 4)
                        
                        Button(action: {
                            copyToClipboard(text: vm.stateNumber)
                            provideHapticFeedbackHeavy()
                            
                        }) {
                            LicensePlateView(stateNumber: vm.stateNumber)
                        }
                        
                        HStack(spacing: 16) {
                            Label(String(vm.year), systemImage: "calendar")
                            
                            Button(action: {
                                copyToClipboard(text: vm.vinNumber)
                                provideHapticFeedbackHeavy()
                            }) {
                                Label("VIN: \(vm.vinNumber)", systemImage: "doc.text.magnifyingglass")
                            }
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding()
                    }
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            MileageCardView(carProfileViewModel: vm)
                            RefuelCardView() // ??
                        }
                        
                        WebViewScreen()
                        
                        if let selectedCar = vm.selectedCar {
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
                    CarSelectionCarouselView(carStore: carStore, carProfileViewModel: vm, isSelecting: $isSelecting)
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

    return CarProfileView(
        carStore: carStore,
        insuranceStore: insuranceStore,
        showTapBar: .constant(true)
    )
}




