//
//  SelectRowCarView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 29.10.2024.
//

import SwiftUI

struct SelectRowCarView: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    @State var blackRed: Color = Color("blackRed")
    
    var car: Car
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    if let imageData = car.photoCar {
                        if let image = UIImage(data: imageData) {
                            Image(uiImage: image)
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipped()
                                .mask {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                }
                                .overlay(
                                       RoundedRectangle(cornerRadius: 8)
                                           .stroke(carViewModel.selectedCar?.id == car.id ? Color.blackRed : Color.clear, lineWidth: 2)
                                           .animation(.easeInOut(duration: 0.3), value: carViewModel.selectedCar?.id)
                                   )
                                .shadow(color: carViewModel.selectedCar?.id == car.id ? Color.gray.opacity(1) : Color.clear, radius: 10)
                                .saturation(carViewModel.selectedCar?.id == car.id ? 1 : 0)
                            
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
                            .font(.title3)
                            .bold()
                        Text("Mileage: \(String(car.mileage)) km")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("VIN Number: \(car.vinNumber ?? "Unknown")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

#Preview {
    let context = CoreDataManaged.shared.context
    
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
