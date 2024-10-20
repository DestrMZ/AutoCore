//
//  SelectCarView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 19.10.2024.
//

import SwiftUI


struct SelectCarView: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    
    @State private var showAddCar: Bool = false
    @State private var selectedCar: Car? = nil
    @State private var isPresented: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    @State private var carIndexForDelete: IndexSet? = nil
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .center) {
                Text("Select of Add a Car")
                    .font(.headline)
                    .padding(.top, 10)
                
                List(carViewModel.allCars, id: \.self) { car in
                    HStack {
                        
                        if let imageData = car.photoCar {
                            if let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    .shadow(radius: 5)
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 60, height: 60)
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                    .shadow(radius: 5)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(car.nameModel ?? "Unknown")")
                                .font(.headline)
                                .bold()
                            Text("Mileage: \(String(car.mileage)) km")
                                .font(.subheadline)
                            Text("VIN Number: \(car.vinNumber ?? "Unknown")")
                                .font(.subheadline)
                        }
                    }
                    .onTapGesture {
                        selectCar(for: car)
                    }
                    .onLongPressGesture {
                        selectedCar = car
                        if let indexCar = carViewModel.allCars.firstIndex(where: { $0.id == car.id }) {
                            carIndexForDelete = IndexSet(integer: indexCar)
                        }
                        showDeleteConfirmation = true
                    }
                    .background(carViewModel.selectedCar == car ? Color.gray.opacity(0.2) : Color.clear)
                }
                
                Button(action: {
                    isPresented = true
                }) {
                    Text("Add new car")
                }
                
            }
        }
        .sheet(isPresented: $isPresented) {
            AddNewCar()
        }
        .onAppear {
            carViewModel.getAllCars()
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(title: Text("Delete car"), message: Text("Are you sure you want to delete \(carViewModel.nameModel)?"), dismissButton: .destructive(Text("Delete")) {
                if let indexCar = carIndexForDelete {
                    carViewModel.deleteCarFromList(at: indexCar)
                }
            })
        }
    }
    private func selectCar(for car: Car) {
        selectedCar = car
        carViewModel.selectedCar = car
        carViewModel.loadCarInfo(for: car)
        print("Select car: \(car.nameModel ?? "Unknown")")
    }
}

#Preview {
    SelectCarView()
}
