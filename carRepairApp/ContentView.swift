////
////  ContentView.swift
////  carRepairApp
////
////  Created by Ivan Maslennikov on 09.10.2024.
////


import SwiftUI


struct ContentView: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    
    var body: some View {
        
        VStack {
            
            if carViewModel.allCars.isEmpty {
                WelcomeCarView()
            } else {
                MainView()
            }
        }.onAppear {
            carViewModel.getAllCars()
        }
    }
}


#Preview {
    ContentView()
}
