//
//  CarTabContainerView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 30.05.2025.
//

import SwiftUI

struct CarSelectionCarouselView: View {
    private var carStore: CarStore
    
    @ObservedObject var dashboardViewModel: DashboardViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var isSelecting: Bool
    
    @State private var selectedTabIndex = 0
    @State private var isAdditingNewCar = false
    @State private var showDeleteConfirmantion = false
    @State private var carForRemoval = ""
    @State private var carToDelete: CarModel?
    
    init(carStore: CarStore, dashboardViewModel: DashboardViewModel, isSelecting: Binding<Bool>) {
        self.carStore = carStore
        self.dashboardViewModel = dashboardViewModel
        self._isSelecting = isSelecting
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTabIndex) {
                ForEach(Array(dashboardViewModel.cars.enumerated()), id: \.offset) { index, car in
                    CarPlaceholderView(car: car)
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 500)
                        .padding(.vertical, 10)
                        .onTapGesture {
                            dashboardViewModel.selectCar(carModel: car)
                            withAnimation { isSelecting = false }
                        }
                        .overlay(alignment: .top) {
                            if dashboardViewModel.selectedCar?.id == car.id {
                                Image(systemName: "person.circle")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.primary)
                                    .shadow(radius: 3)
                                    .padding(.vertical, -20)
                            }
                        }
                        .overlay(alignment: .topTrailing) {
                            Button {
                                carForRemoval = car.nameModel
                                carToDelete = car
                                showDeleteConfirmantion = true
                            } label: {
                                Image(systemName: "trash.fill")
                                    .font(.system(size: 25))
                                    .foregroundStyle(.red)
                                    .shadow(radius: 3)
                                    .padding(20)
                            }
                        }
                }
                
                Button { isAdditingNewCar = true } label: {
                    AddPlaceholderCarView()
                }
                .tag(dashboardViewModel.cars.count)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .animation(.default, value: dashboardViewModel.cars)
        }
        .fullScreenCover(isPresented: $isAdditingNewCar) {
            AddCarView(carStore: carStore)
        }
        .alert("Delete car", isPresented: $showDeleteConfirmantion) {
            Button("Yes", role: .destructive) {
                if let car = carToDelete {
                    dashboardViewModel.deleteCar(car: car)
                }
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure want to delete \(carForRemoval)?")
        }
    }
}

//#Preview {
//    CarSelectionCarouselView(isSelecting: .constant(true))
//        .environmentObject(CarViewModel())
//}
