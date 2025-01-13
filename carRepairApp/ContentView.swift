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
            MainView()
        }
    }
}


#Preview {
    ContentView()
}
