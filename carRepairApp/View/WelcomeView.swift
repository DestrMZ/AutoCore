//
//  AddCarView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 11.10.2024.
//

import SwiftUI

struct WelcomeCarView: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    @State var continueView: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                Text("Welcome to AutoCare!")
                    .font(.title)
                    .bold()
                    .padding(.top, 150)
                Text("Go ahead and add your car details")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Image("car")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                
                Spacer()
                
                NavigationLink(destination: AddCarView()) {
                    Text("Go")
                        .font(Font.system(size: 20))
                        .frame(width: 120, height: 20)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(30)
                        .padding(.bottom, 70)
                }.navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    WelcomeCarView()
}
