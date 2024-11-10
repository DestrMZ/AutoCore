//
//  SelectCar.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 29.10.2024.
//

import SwiftUI

struct SelectCarView: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    
    @State private var showAddCar: Bool = false
    @State private var selectedCar: Car? = nil
    @State private var carIndexForDelete: IndexSet? = nil
    
    @State private var tabSelect = ""
    @State private var showDeleteConfirmantion: Bool = false
   
    var body: some View {
        NavigationStack {
            ScrollView {
                mainScreen
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Edit") {
                                // TODO: Add logit for edit list car
                            }
                            .foregroundStyle(.red)
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button(action: {
                                showAddCar.toggle() // TODO: Add func for create new car
                            }) {
                                Image(systemName: "plus.circle")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                
                
                Spacer()
            }
            .onAppear {
                carViewModel.getAllCars()
            }
            .alert(isPresented: $showDeleteConfirmantion) {
                Alert(title: Text("Delete car"),
                      message: Text("Are you sure want to delete \(tabSelect)"),
                      primaryButton: .destructive(Text("Yes, delete")) {
                    if let indexCar = carIndexForDelete {
                        carViewModel.deleteCarFromList(at: indexCar)
                    }
                },
                      secondaryButton: .cancel()
                )
            }
        }
    }
    
    var mainScreen: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Сars in the garage")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            ForEach(carViewModel.allCars, id: \.self) { car in
                HStack {
                    SelectRowCarView(car: car)
                    
                    Spacer()
                    
                    if carViewModel.selectedCar == car {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.title3)
                            .padding(.trailing, 16)
                    }
                }
                .padding(.horizontal, 20)
                .onTapGesture {
                    selectCar(for: car)
                }
                .onLongPressGesture {
                    selectedCar = car
                    if let indexCar = carViewModel.allCars.firstIndex(where: { $0.id == car.id }) {
                        carIndexForDelete = IndexSet(integer: indexCar)
                        tabSelect = car.nameModel ?? "Not found"
                    }
                    showDeleteConfirmantion = true
                }
            }
        }
    }
    
    private func selectCar(for car: Car) {
        selectedCar = car
        carViewModel.selectedCar = car
        carViewModel.loadCarInfo(for: car)
        print("Select car: \(car.nameModel ?? "Not found")")
    }
}

#Preview {
    SelectCarView()
        .environmentObject(CarViewModel())
}
