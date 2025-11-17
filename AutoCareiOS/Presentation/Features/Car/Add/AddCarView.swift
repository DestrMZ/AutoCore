//
//  NewCar.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 11.11.2024.
//

import SwiftUI
import PhotosUI

struct AddCarView: View {
    @StateObject private var addCarViewModel: AddCarViewModel
    
    init(carStore: CarStore) {
        self._addCarViewModel = StateObject(wrappedValue: AddCarViewModel(carStore: carStore))
    }
    
    var body: some View {
        NavigationStack {
            
        }
    }
}

//#Preview {
//    AddCarView()
//        .environmentObject(CarViewModel())
//}
