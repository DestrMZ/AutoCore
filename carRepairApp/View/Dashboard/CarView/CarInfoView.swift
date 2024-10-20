//
//  CarInfoView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 12.10.2024.
//

import SwiftUI

struct CarInfoView: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("Name:")
                    .font(.headline)
                Text(carViewModel.nameModel)
                    .font(.body)
            }
            
            HStack {
                Text("Year:")
                    .font(.headline)
                Text("\(carViewModel.year)")
                    .font(.body)
            }
            
            HStack {
                Text("VIN number:")
                    .font(.headline)
                Text(carViewModel.vinNumber)
                    .font(.body)
            }
            
            HStack {
                Text("Color:")
                    .font(.headline)
                Text(carViewModel.color)
                    .font(.body)
            }
            
            HStack {
                Text("Mileage:")
                    .font(.headline)
                Text("\(carViewModel.mileage)")
                    .font(.body)
            }
            
            HStack {
                Text("Engine type:")
                    .font(.headline)
                Text(carViewModel.engineType.rawValue)
                    .font(.body)
            }
            
            HStack {
                Text("Transmission type:")
                    .font(.headline)
                Text(carViewModel.transmissionType.rawValue)
                    .font(.body)
            }
            
            
        }
        .frame(maxWidth: .infinity) 
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .onAppear {
            if let selectedCar = carViewModel.selectedCar {
                carViewModel.loadCarInfo(for: selectedCar)
            }
            // Загружаем из CarViewModel информацию об автомобиле, указывая о каком именно авто нам нужна информация.
        }
    }
}

#Preview {
    CarInfoView()
        .environmentObject(CarViewModel())
}
