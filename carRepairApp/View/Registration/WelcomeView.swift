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
    
    var colorCitron: Color = Color("Citron")
    var colorDavyGray: Color = Color("DavyGray")
    var colorDim: Color = Color("Dim")
    var colorDimGray: Color = Color("DimGray")
    var colorTeaGreen: Color = Color("TeaGreen")
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                 
                Text("Welcome to AutoCare!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.top, 150)
                Text("Go ahead and add your car details")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.white)
                
                Spacer()
                
                Image("car2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                
                Spacer()
                
                NavigationLink(destination: AddCarView()) {
                    Text("Go")
                        .font(Font.system(size: 20))
                        .frame(width: 90, height: 20)
                        .foregroundColor(.black)
                        .padding()
                        .background(colorCitron)
                        .cornerRadius(30)
                        .padding(.bottom, 70)
                }.navigationBarBackButtonHidden(true)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(colorDimGray)
        }
    }
}

#Preview {
    WelcomeCarView()
        .environmentObject(CarViewModel())
}
