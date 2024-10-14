////
////  ContentView.swift
////  carRepairApp
////
////  Created by Ivan Maslennikov on 09.10.2024.
////


import SwiftUI


struct ContentView: View {
    @EnvironmentObject var carViewModel: CarViewModel
    @State var carArray: [Car] = [] // Плпробовать реализовать через ViewModel [Car]
    
    
    var body: some View {
        
        VStack {
            
            if carArray.isEmpty {
                WelcomeCarView()
            } else {
                MainView()
            }
        }.onAppear {
            carArray = CoreDataManaged.shared.getAllCars()
            print(carArray)
        }
    }
}


//#Preview {
//    ContentView()
//}
