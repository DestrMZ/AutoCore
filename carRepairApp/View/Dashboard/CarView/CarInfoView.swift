//
//  CarInfoView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 12.10.2024.
//

import SwiftUI

struct CarInfoView: View {
    
    @EnvironmentObject var car: CarViewModel
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("Name:")
                    .font(.headline)
                Text(car.nameModel)
                    .font(.body)
            }
            
            HStack {
                Text("Year:")
                    .font(.headline)
                Text("\(car.year)")
                    .font(.body)
            }
            
            HStack {
                Text("VIN number:")
                    .font(.headline)
                Text(car.vinNumber)
                    .font(.body)
            }
            
            HStack {
                Text("Color:")
                    .font(.headline)
                Text(car.color)
                    .font(.body)
            }
            
            HStack {
                Text("Mileage:")
                    .font(.headline)
                Text("\(car.mileage)")
                    .font(.body)
            }
            
            HStack {
                Text("Date of purchase:")
                    .font(.headline)
                Text(dateFormatter().string(from: car.dateOfPurchase))
                    .font(.body)
            }
            
            HStack {
                Text("Engine type:")
                    .font(.headline)
                Text(car.engineType.rawValue)
                    .font(.body)
            }
            
            HStack {
                Text("Transmission type:")
                    .font(.headline)
                Text(car.transmissionType.rawValue)
                    .font(.body)
            }
            
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .onAppear {
            car.loadCarInfo()
        }
    }
}

#Preview {
    CarInfoView()
        .environmentObject(CarViewModel())
}
