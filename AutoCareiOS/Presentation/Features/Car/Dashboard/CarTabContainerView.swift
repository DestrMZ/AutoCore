//
//  CarTabContainerView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 30.05.2025.
//

import SwiftUI

struct CarSelectionCarouselView: View {
    @EnvironmentObject var carViewModel: CarViewModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var isSelecting: Bool
    
    @State private var selectedTabIndex = 0
    @State var isAdditingNewCar: Bool = false
    @State var showDeleteConfirmantion: Bool = false
    @State var сarForRemoval: String = ""
    @State var carToDelete: CarModel? = nil
    
    var body: some View {
        
        ZStack {
            TabView(selection: $selectedTabIndex) {
                ForEach(Array(carViewModel.cars.enumerated()), id: \.offset) { index, car in
                    
                    CarPlaceholderView(car: car)
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 500)
                        .padding(.vertical, 10)
                        .animation(.easeInOut(duration: 0.5), value: selectedTabIndex)
                        .onTapGesture {
                                carViewModel.selectedCar = carViewModel.cars[selectedTabIndex]
                            withAnimation {
                                isSelecting = false
                            }
                        }
                        .overlay(alignment: .top) {
                            if let currentCar = carViewModel.selectedCar, currentCar == car {
                                Image(systemName: "person.circle")
                                    .font(Font.system(size: 20))
                                    .foregroundStyle(.primary)
                                    .shadow(radius: 3)
                                    .padding(.vertical, -20)
                            }
                        }
                        .overlay(alignment: .topTrailing) {
                            Button(action: {
                                showDeleteConfirmantion = true
                                сarForRemoval = car.nameModel
                                carToDelete = car
                            }) {
                                Image(systemName: "trash.fill")
                                    .font(Font.system(size: 25))
                                    .foregroundStyle(.red)
                                    .shadow(radius: 3)
                                    .padding(20)
                            }
                        }
                }
                
                Button(action: {
                    isAdditingNewCar = true
                }) {
                    AddPlaceholderCarView()
                }
                .tag(carViewModel.cars.count)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        }
        .fullScreenCover(isPresented: $isAdditingNewCar) {
            AddCarView()
        }
        .alert(isPresented: $showDeleteConfirmantion) {
            Alert(title: Text("Delete car"),
                  message: Text("Are you sure want to delete \(сarForRemoval)"),
                  primaryButton: .destructive(Text("Yes")) {
                if let car = carToDelete {
                    carViewModel.deleteCar(carModel: car)
                }

                dismiss()
            },
                  secondaryButton: .cancel()
            )
        }
    }
}

//#Preview {
//    CarSelectionCarouselView(isSelecting: .constant(true))
//        .environmentObject(CarViewModel())
//}
