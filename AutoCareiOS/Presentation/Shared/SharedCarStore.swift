//
//  SharedCarStore.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 31.07.2025.
//

import Foundation


final class SharedCarStore: ObservableObject {
    @Published var cars: [CarModel] = []
    @Published var selectedCar: CarModel?
    
    func addCar(_ car: CarModel) {
        cars.append(car)
    }
    
    func deleteCar(at index: Int) {
        cars.remove(at: index)
    }
    
    func selectCar(_ carModel: CarModel) {
        selectedCar = carModel
    }
}
