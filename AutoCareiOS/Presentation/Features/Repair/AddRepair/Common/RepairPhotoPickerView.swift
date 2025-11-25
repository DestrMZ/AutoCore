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
    
    @ObservedObject var addRepairViewModel: AddRepairViewModel
    @State var selectedImagesRepair: [PhotosPickerItem] = []
    
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
                    await addRepairViewModel.loadPhotos(from: selectedImagesRepair)
                }
            }
        }
    }
}
