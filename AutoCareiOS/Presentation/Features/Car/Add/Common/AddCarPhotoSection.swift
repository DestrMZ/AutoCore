//
//  AddCarPhotoSection.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 16.11.2025.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct AddCarPhotoSection: View {
    
    @Binding var selectionImageCar: PhotosPickerItem?
    @Binding var avatarImage: UIImage?
    
    var body: some View {
        VStack(spacing: 16) {
            if let avatarImage {
                Image(uiImage: avatarImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            HStack {
                Spacer()
                PhotosPicker(selection: $selectionImageCar, matching: .images) {
                    Text("Add photo")
                        .frame(width: 110, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundStyle(.white)
                }
                Spacer()
            }
        }
        .onChange(of: selectionImageCar) { newValue in
            guard let newValue else { return }
            newValue.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let imageData):
                    if let imageData, let image = UIImage(data: imageData) {
                        self.avatarImage = image
                    }
                case .failure(let error):
                    print("Ошибка добавления фотографии авто: \(error)")
                }
            }
        }
    }
}
