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
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .center) {
                Text("Select of Add a Car")
                    .font(.headline)
                    .padding(.top, 10)
                
                List(carViewModel.allCars, id: \.self) { car in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(car.nameModel ?? "Unknown")")
                                .font(.headline)
                            Text("Mileage: \(car.mileage)")
                                .font(.subheadline)
                        }
                        Spacer()
                        
                        if let imageData = car.photoCar {
                            if let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectCar(for: car)
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
