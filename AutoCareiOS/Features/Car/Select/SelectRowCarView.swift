//
//  SelectRowCarView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 29.10.2024.
//

import SwiftUI

struct SelectRowCarView: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var car: Car
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                if let imageData = car.photoCar, let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    carViewModel.selectedCar?.id == car.id ? Color.blackRed : Color.clear,
                                    lineWidth: 2
                                )
                                .animation(.easeInOut(duration: 0.3), value: carViewModel.selectedCar?.id)
                        )
                        .shadow(
                            color: carViewModel.selectedCar?.id == car.id ? Color.gray.opacity(0.6) : Color.clear,
                            radius: 6
                        )
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Circle()
                                .stroke(
                                    carViewModel.selectedCar?.id == car.id ? Color.blackRed : Color.gray.opacity(0.4),
                                    lineWidth: 2
                                )
                                .animation(.easeInOut(duration: 0.3), value: carViewModel.selectedCar?.id)
                        )
                        .shadow(
                            color: carViewModel.selectedCar?.id == car.id ? Color.gray.opacity(0.6) : Color.clear,
                            radius: 6
                        )
                }
                
                VStack(alignment: .leading) {
                    Text("\(car.nameModel ?? "Unknown")")
                        .font(.title3)
                        .bold()
                    Text("VIN Number: \(car.vinNumber ?? "Unknown")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

#Preview {
    let context = CoreDataStack.shared.context
    
    let car1 = Car(context: context)
    car1.nameModel = "Audi"
    car1.mileage = 100_000
    car1.vinNumber = "123456789"
    
    let car2 = Car(context: context)
    car2.nameModel = "BMW"
    car2.mileage = 200_000
    car2.vinNumber = "987654321"
    
    let car3 = Car(context: context)
    car3.nameModel = "Mercedes"
    car3.mileage = 300_000
    car3.vinNumber = "654321098"
    
    let carViewModel = CarViewModel()
    
    return Group {
        SelectRowCarView(car: car1)
            .environmentObject(carViewModel)
        SelectRowCarView(car: car2)
            .environmentObject(carViewModel)
        SelectRowCarView(car: car3)
            .environmentObject(carViewModel)
    }
}
