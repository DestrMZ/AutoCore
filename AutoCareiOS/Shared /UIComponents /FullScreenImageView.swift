//
//  FullScreenImageView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 26.03.2025.
//

import SwiftUI

struct FullScreenImageView: View {
    @Binding var selectImage: UIImage?
    @Environment(\.dismiss) var dismiss
    
    @State var showAlertPhoto: Bool = false
    
    var body: some View {
        ZStack {
            
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if let image = selectImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black)
                        .clipped()
                } else {
                    Text("Failed to load image!")
                        .font(.title3)
                        .foregroundStyle(.white)
                }
            }
        }
        .overlay(alignment: .topLeading) {
            HStack {
                Button(action: {
                    saveImageToDevice(image: selectImage)
                    showAlertPhoto = true
                }) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .padding()
                        .background(Circle().fill(Color.black.opacity(0.5)))
                }
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.black.opacity(0.5)))
                }
            }
        }
        .alert(NSLocalizedString("Great, the image has been added to the gallery.", comment: ""), isPresented: $showAlertPhoto) {
            Button("OK", role: .cancel) {}
        }
    }
}

#Preview {
//    FullScreenImageView()
}
