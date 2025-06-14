//
//  CarAvatarView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 28.05.2025.
//

import SwiftUI

struct CarAvatarView: View {
    let image: UIImage?
    let imagePlaceHolder: UIImage = UIImage(named: "imageNotCar 1") ?? UIImage()
    
    var body: some View {
        ZStack() {
            VStack {}
                .frame(height: 400)
                .background(
                    Blur(effect: UIBlurEffect(style: .dark))
                        .preferredColorScheme(.dark)
                )
                
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: 500)
                    .mask(LinearGradient(stops: [.init(color: .white, location: 0),
                                                 .init(color: .white, location: 0.5),
                                                 .init(color: .clear, location: 0.80),], startPoint: .top, endPoint: .bottom))
                    .clipped()
            } else {
                Image(uiImage: imagePlaceHolder)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: 500)
                    .mask(LinearGradient(stops: [.init(color: .white, location: 0),
                                                 .init(color: .white, location: 0.5),
                                                 .init(color: .clear, location: 0.80),], startPoint: .top, endPoint: .bottom))
            }
        }
    }
}

struct Blur: UIViewRepresentable {
    
    var effect: UIBlurEffect
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView()
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}

#Preview {
    CarAvatarView(image: nil)
}
