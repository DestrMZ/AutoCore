//
//  CarCardView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 17.11.2025.
//

import SwiftUI
import PhotosUI

struct CarCardView: View {
    @Binding var name: String
    @Binding var stateNumber: String
    @Binding var vin: String
    @Binding var mileage: String
    @Binding var avatarImage: UIImage?

    @State var selectionImageCar: PhotosPickerItem?
    
    private let placeHolderImage: UIImage = UIImage(named: "imageNotCar 1") ?? UIImage()

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Group {
                if let avatarImage {
                    Image(uiImage: avatarImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(uiImage: placeHolderImage)
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(height: 190)
            .frame(maxWidth: .infinity, alignment: .bottom)

            VStack(alignment: .leading, spacing: 6) {
                
                Text(name.isEmpty ? "New car" : name)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)

                if !stateNumber.isEmpty {
                    Text(stateNumber)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white.opacity(0.9))
                }

                HStack(spacing: 12) {
                    if !vin.isEmpty {
                        Label("VIN: \(vin)", systemImage: "doc.text.magnifyingglass")
                    }
                    if !mileage.isEmpty {
                        Label("\(mileage) km", systemImage: "gauge.with.dots.needle.67percent")
                    }
                }
                .font(.caption)
                .foregroundStyle(.white.opacity(0.9))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            PhotosPicker(selection: $selectionImageCar, matching: .images) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .padding(12),
            alignment: .topTrailing
        )
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 8)
        .onChange(of: selectionImageCar) { newValue in
            guard let newValue else { return }
            newValue.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let imageData):
                    if let imageData, let image = UIImage(data: imageData) {
                        avatarImage = image
                    }
                case .failure(let error):
                    print("Ошибка добавления фотографии авто: \(error)")
                }
            }
        }
    }
    
}

#Preview {
    struct CarCardPreviewWrapper: View {
        @State private var name: String = "Toyota Corolla"
        @State private var stateNumber: String = "О611ТВ790"
        @State private var vin: String = "JTNBB46K123456789"
        @State private var mileage: String = "124 500"
        @State private var image: UIImage? = nil

        var body: some View {
            CarCardView(
                name: $name,
                stateNumber: $stateNumber,
                vin: $vin,
                mileage: $mileage,
                avatarImage: $image
            )
        }
    }

    return CarCardPreviewWrapper()
}
