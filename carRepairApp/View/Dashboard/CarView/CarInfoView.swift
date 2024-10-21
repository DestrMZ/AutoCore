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
        VStack(alignment: .leading, spacing: 7) {
            
            HStack() {
                Text("Your car:")
                    .font(.headline)
                Spacer()
                Text(carViewModel.nameModel)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("Year:")
                    .font(.headline)
                Spacer()
                Text("\(carViewModel.year)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("VIN number:")
                    .font(.headline)
                Spacer()
                Text(carViewModel.vinNumber)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("Color:")
                    .font(.headline)
                Spacer()
                Text(carViewModel.color)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("Mileage:")
                    .font(.headline)
                Spacer()
                Text("\(carViewModel.mileage)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("Engine type:")
                    .font(.headline)
                Spacer()
                Text(carViewModel.engineType.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text("Transmission type:")
                    .font(.headline)
                Spacer()
                Text(carViewModel.transmissionType.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: 350)
        .padding(10)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 4)
        )
        .background(Color.white)
        .shadow(radius: 10)
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
