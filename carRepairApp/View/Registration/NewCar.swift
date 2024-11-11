//
//  NewCar.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 11.11.2024.
//

import SwiftUI

struct NewCar: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    
    @State var buttonToNext: Bool = false
    @State var showAlert: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                HStack {
                    Text("Add")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.primary)
                        .padding(.top, 10)
                    Image("newCar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                
                Divider()
                
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 25) {
                        
                        TextField("Model", text: $carViewModel.nameModel)
                        
                        TextField("Year", value: $carViewModel.year, formatter: yearFormatter())
                        
                        TextField("VIN", text: $carViewModel.vinNumber)
                        
                        TextField("Mileage", value: $carViewModel.mileage, formatter: mileageFormatter())
                        
                        Picker("Engine type", selection: $carViewModel.engineType) {
                            ForEach(EngineTypeEnum.allCases, id: \.self) {
                                engineType in
                                Text(engineType.rawValue.capitalized)
                                    .tag(engineType)
                            }
                        }
                        .pickerStyle(.navigationLink)
                        .foregroundStyle(.primary)
                        
                        Picker("Transmission type", selection: $carViewModel.transmissionType) {
                            ForEach(TransmissionTypeEnum.allCases, id: \.self) { transmissionType in
                                Text(transmissionType.rawValue.capitalized)
                                    .tag(transmissionType)
                            }
                        }
                        .pickerStyle(.navigationLink)
                        .foregroundStyle(.primary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
    }
}

#Preview {
    NewCar()
        .environmentObject(CarViewModel())
}
