//
//  SharedCarStore.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 31.07.2025.
//

import Foundation

final class SharedCarStore: ObservableObject {
    
    @Published var cars: [Car] = []
    @Published var selectedCar: Car?
    
}
