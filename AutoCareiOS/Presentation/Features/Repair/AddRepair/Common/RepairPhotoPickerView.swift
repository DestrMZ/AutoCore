//
//  RepairPhotoPickerView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 19.07.2025.
//

import Foundation
import SwiftUI
import PhotosUI


struct RepairPhotoPickerView: View {
    
    @State var selectedImagesRepair: [PhotosPickerItem] = []
    
    @Binding var photoRepair: [Data]
    @Binding var showSuccessMessage: Bool
    
    var body: some View {
        HStack {
            Text("Photo")
            Spacer()
            PhotosPicker(selection: $selectedImagesRepair, maxSelectionCount: 10, matching: .images, photoLibrary: .shared()) {
                Image(systemName: "photo.badge.plus")
                    .font(.largeTitle)
                    .foregroundStyle(.blackRed)
            }
            .onChange(of: selectedImagesRepair) { newItem in
                Task {
                    await handleSelectedPhotos(items: newItem)
                }
            }
        }
    }
    
    @MainActor
    private func handleSelectedPhotos(items: [PhotosPickerItem]) async {
        var photo: [Data] = []

        await withTaskGroup(of: Data?.self) { group in
            for item in items {
                group.addTask {
                    try? await item.loadTransferable(type: Data.self)
                }
            }

            for await result in group {
                if let data = result {
                    photo.append(data)
                }
            }
        }

        if !photo.isEmpty {
            photoRepair.append(contentsOf: photo)
            showSuccessMessage = true
        }
    }
}
