////
////  ContentView.swift
////  carRepairApp
////
////  Created by Ivan Maslennikov on 09.10.2024.
////


import SwiftUI


struct ContentView: View {
    
    let container: AppDIContainer
    
    var body: some View {
        VStack {
            MainView(container: container)
        }
    }
}


#Preview {
    let container: AppDIContainer = .shared
    ContentView(container: container)
}
