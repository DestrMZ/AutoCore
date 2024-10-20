//
//  AddNewCar.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 19.10.2024.
//


import SwiftUI
import PhotosUI

struct AddNewCar: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    @State var showAlert: Bool = false
    
    @State private var selectionImageCar: PhotosPickerItem?
    @State private var avatarImage: UIImage?
    
    var colorCitron: Color = Color("Citron")
    var colorDavyGray: Color = Color("DavyGray")
    var colorDim: Color = Color("Dim")
    var colorDimGray: Color = Color("DimGray")
    var colorTeaGreen: Color = Color("TeaGreen")
    
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
                    
                    Group {
                        VStack(spacing: 30) {
                            
                            CustomUITextField(text: $carViewModel.nameModel, title: "Модель")
                            CustomUITextField(text: Binding(
                                get: { String(carViewModel.year) },
                                set: { carViewModel.year = Int16($0) ?? 0 }
                            ), title: "Year")
                            CustomUITextField(text: $carViewModel.vinNumber, title: "VIN")
                            CustomUITextField(text: $carViewModel.color, title: "Цвет")
                            CustomUITextField(text: Binding(
                                get: { String(carViewModel.mileage) },
                                set: { carViewModel.mileage = Int32($0) ?? 0 }
                            ), title: "Mileage")
                            
                            
                            
                            Picker("Engine type", selection: $carViewModel.engineType) {
                                ForEach(EngineTypeEnum.allCases, id: \.self) { engineType in
                                    Text(engineType.rawValue.capitalized)
                                        .tag(engineType)
                                }
                            }.pickerStyle(.navigationLink)
                                .pickerStyle(.navigationLink)
                                .foregroundColor(.primary)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 15)
                                .background(Color.gray)
                                .cornerRadius(8)
                                .padding(.horizontal, 35)
                            
                            Picker("Transmission type", selection: $carViewModel.transmissionType) {
                                ForEach(TransmissionTypeEnum.allCases, id: \.self) { transmissionType in
                                    Text(transmissionType.rawValue.capitalized)
                                        .tag(transmissionType)
                                }
                            }.pickerStyle(.navigationLink)
                                .pickerStyle(.navigationLink)
                                .foregroundColor(.primary)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 15)
                                .background(Color.gray)
                                .cornerRadius(8)
                                .padding(.horizontal, 35)
                        }
                        .padding(.top, 25)
                    }
                    
                    Button(action: {
                            carViewModel.createNewCar()
                    }) {
                        Text("Save")
                            .font(Font.system(size: 20))
                            .frame(width: 120, height: 20)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(30)
                            .padding(.bottom, 70)
                    }
                    .padding(.bottom, 20)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Упс"), message: Text("Пожалуйста, заполните все поля"), dismissButton: .default(Text("OK")))
                        }
                    }
                }
            .background()
            
            PhotosPicker(selection: $selectionImageCar, matching: .images) {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
            }
            .onChange(of: selectionImageCar) { oldItem, newItem in
                if let newItem = newItem {
                    
                    newItem.loadTransferable(type: Data.self) { result in
                        switch result {
                        case .success(let imageData):
                            if let imageData = imageData, let image = UIImage(data: imageData) {
                                self.avatarImage = image
                            }
                        case .failure(_):
                            print("Ошибка загрузки изображения")
                        }
                    }
                }
            }
            
            }
            .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    AddNewCar()
        .environmentObject(CarViewModel())
}
