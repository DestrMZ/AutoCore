//
//  AddCarView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 11.10.2024.
//

import SwiftUI

struct AddCarView: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    @State var buttonToContinue: Bool = false
    
    var body: some View {
        
        NavigationStack {
        
            VStack {
                Text("Enter Your Car Details")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.primary)
                    .padding()
                
                Divider()
                
                ScrollView {
                    VStack(spacing: 30) {
                        
                        CustomUITextField(text: $carViewModel.nameModel, title: "Model")
                        
                        CustomUITextField(text: Binding(
                            get: { String(carViewModel.year) },
                            set: { carViewModel.year = Int16($0) ?? 0 }
                        ), title: "Year")
                        
                        CustomUITextField(text: $carViewModel.vinNumber, title: "VIN")
                        
                        CustomUITextField(text: $carViewModel.color, title: "Color")
                        
                        CustomUITextField(text: Binding(
                            get: { String(carViewModel.mileage) },
                            set: { carViewModel.mileage = Int32($0) ?? 0 }
                        ), title: "Mileage")
                        
                        CustomUITextField(text: $carViewModel.engineType, title: "Engine Type")
                        
                        CustomUITextField(text: $carViewModel.transmissionType, title: "Transmission Type")
                        
                        DatePicker("Date of Purchase", selection: $carViewModel.dateOfPurchase, displayedComponents: .date)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .datePickerStyle(.automatic)
                            .accentColor(.red)
                    }
                    .padding(.top, 25)
                    
                    Button(action: {
                        if !carViewModel.nameModel.isEmpty && !carViewModel.vinNumber.isEmpty && !carViewModel.color.isEmpty && !carViewModel.engineType.isEmpty && !carViewModel.transmissionType.isEmpty {
                            
                            carViewModel.createNewCar()
                            buttonToContinue = true
                        } else {
                            print("Заполните все поля")
                        }
                    }) {
                        Text("Next")
                            .font(Font.system(size: 20))
                            .frame(width: 120, height: 20)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(30)
                            .padding(.bottom, 70)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationDestination(isPresented: $buttonToContinue) {
                MainView()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
#Preview {
    AddCarView()
        .environmentObject(CarViewModel())
}
