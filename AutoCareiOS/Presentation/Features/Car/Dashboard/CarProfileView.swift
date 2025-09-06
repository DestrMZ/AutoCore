//
//  MainCarView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 18.05.2025.
//

import SwiftUI
import TipKit


struct CarProfileView: View {
    
    let container: AppDIContainer
    
    @ObservedObject var sharedCarStore: SharedCarStore
    
    @EnvironmentObject var carViewModel: CarViewModel
    @Environment(\.dismiss) var dismiss

    @State var isSelecting: Bool = false
    @State var showQuestionMark: Bool = false
    
    @Binding var showTapBar: Bool
    
    init(container: AppDIContainer, selectedCar: CarModel?, showTapBar: Binding<Bool>) {
        self.container = container
        self._selectedCar = State(wrappedValue: container.sharedCar.selectedCar)
    }
   
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                CarAvatarView(image: UIImage(data: carViewModel.photoCar))
                
                ScrollView {
                    VStack {
                        Spacer().frame(height: 250)
                        Text("\(carViewModel.nameModel)")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                            .shadow(radius: 4)
                        
                        Button(action: {
                            copyToClipboard(text: carViewModel.stateNumber)
                            provideHapticFeedbackHeavy()
                            
                        }) {
                            LicensePlateView(stateNumber: carViewModel.stateNumber)
                        }
                        
                        HStack(spacing: 16) {
                            Label(String(carViewModel.year), systemImage: "calendar")
                            
                            Button(action: {
                                copyToClipboard(text: carViewModel.vinNumber)
                                provideHapticFeedbackHeavy()
                            }) {
                                Label("VIN: \(carViewModel.vinNumber)", systemImage: "doc.text.magnifyingglass")
                            }
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding()
                    }
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            MileageCardView()
                            RefuelCardView()
                        }
                        
                        WebViewScreen()
                        
                        if let selectedCar = carViewModel.selectedCar {
                            InsuranceListSelection(selectedCar: selectedCar)
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
                    CarSelectionCarouselView(isSelecting: $isSelecting)
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

//#Preview {
//    CarProfileView(showTapBar: .constant(true))
//        .environmentObject(CarViewModel())
//        .environmentObject(RepairViewModel())
//}




