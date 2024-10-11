//
//  MainView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 11.10.2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        
        NavigationStack {
            
            Text("you here main view")
                .font(.title2)
                .bold()
            
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainView()
}
