//
//  ImageView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 12.04.2025.
//

import Foundation
import SwiftUI
import PhotosUI


struct ImageView: View {
    
    @Binding var isRepairEditing: Bool
    @Binding var photoRepair: [Data]
    
    @State var selectedPhotoItems: [PhotosPickerItem] = []
    @State var fullScreenPhoto: UIImage? = UIImage()
    @State var isFullScreenShow: Bool = false
    
    let repair: RepairModel
    
    var body: some View {
        let displayPhotos = isRepairEditing
            ? ImageMapper.convertToUIImage(images: photoRepair)
        : ImageMapper.convertToUIImage(images: repair.photoRepairs)
        
        VStack(alignment: .leading, spacing: 12) {
            Label("Photos", systemImage: "photo.stack.fill")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(displayPhotos.indices, id: \.self) { index in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: displayPhotos[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 280, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                .onTapGesture {
                                    if !isRepairEditing {
                                        fullScreenPhoto = displayPhotos[index]
                                        isFullScreenShow = true
                                    }
                                }
                            
                            if isRepairEditing {
                                Button(action: {
                                    if index < photoRepair.count {
                                        photoRepair.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.system(size: 20))
                                        .background(Circle().fill(Color.white))
                                        .offset(x: -5, y: 5)
                                }
                            }
                        }
                    }
                    
                    if isRepairEditing {
                        PhotosPicker(
                            selection: $selectedPhotoItems,
                            maxSelectionCount: 5,
                            matching: .images
                        ) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 280, height: 200)
                                    .foregroundColor(.gray.opacity(0.2))
                                VStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.blue)
                                    Text(NSLocalizedString("Add Photo", comment: "Detail View"))
                                        .font(.body)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .onChange(of: selectedPhotoItems) { _ in
                            Task {
                                for image in selectedPhotoItems {
                                    if let dataImage = try? await image.loadTransferable(type: Data.self) {
                                        await MainActor.run {
                                            photoRepair.append(dataImage)
                                        }
                                    }
                                }
                                selectedPhotoItems.removeAll()
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .fullScreenCover(isPresented: $isFullScreenShow) {
            FullScreenImageView(selectImage: $fullScreenPhoto)
        }
    }
}
