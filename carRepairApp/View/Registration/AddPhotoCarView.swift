//
//  AddPhotoCarView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 12.10.2024.
//

import SwiftUI
import PhotosUI

@available(iOS 16.0, *)
struct AddPhotoCarView: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    
    @State private var selectionImageCar: PhotosPickerItem?
    @State private var avatarImage: UIImage?
    @State private var continueNextView: Bool = false
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 20) {
                
                Text("Add photo your car")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.primary)
                    .padding()
                
                Divider()
                
                Spacer()
                
                VStack {
                    if let avatarImage = avatarImage {
                        Image(uiImage: avatarImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .cornerRadius(10)
                            .padding()
                    } else {
                        Text("Изображение не выбрано")
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(width: 300, height: 300)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                }
                
                // Выбор изображения
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
                
                Spacer()
                
                Button(action: {
                    if let avatarImage = avatarImage {
                        carViewModel.saveImageCar(imageSelection: avatarImage)
                        continueNextView = true
                    }
                }) {
                    Text("Continue")
                        .font(Font.system(size: 20))
                        .frame(width: 120, height: 20)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(30)
                        .padding(.bottom, 70)
                }
                .padding(.horizontal)
                .disabled(avatarImage == nil)
                
            }
            .padding()
            .navigationDestination(isPresented: $continueNextView) {
                MainView()
            }
            .navigationBarBackButtonHidden(true)
            
        }
    }
}

#Preview {
    AddPhotoCarView()
}




