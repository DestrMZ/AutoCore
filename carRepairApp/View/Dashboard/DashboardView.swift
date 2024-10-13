//
//  DashboardView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 12.10.2024.
//

import SwiftUI

struct DashboardView: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    @State private var carImage: UIImage? = nil
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Auto Care")
                            .font(.title2)
                            .bold()
                        Text("It's simple")
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    if let carImage = carImage {
                        Image(uiImage: carImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            .shadow(radius: 5)
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 100)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            .shadow(radius: 5)
                    }
                }
                .padding(.horizontal, 30)
                
                Divider()
                
                VStack(alignment: .leading) {
                    
                    ZStack {
                        CarInfoView()
                    }
                    
                }
                
                
                
                
                
            }
        }.navigationBarBackButtonHidden(true)
            .onAppear {
                if let image = carViewModel.getImageCar() {
                    carImage = image
                    print("Изображение загружено")
                } else {
                    print("Изображение не найдено")
                }
            }
    }
}

#Preview {
    DashboardView()
        .environmentObject(CarViewModel())
}
