//
//  CarPlaceholderView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 31.05.2025.
//

import SwiftUI

struct CarPlaceholderView: View {
    
    let imagePlaceHolder: UIImage = UIImage(named: "imageNotCar 1") ?? UIImage()
    let car: CarModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let image = UIImage(data: car.photoCar) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                } else {
                    Image(uiImage: imagePlaceHolder)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        
                }
                
                VStack {
                    Spacer()
                    Text(car.nameModel)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                        .padding(.bottom, 24)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.95, height: 500)
        .cornerRadius(32)
    }
}


//#Preview {
//    let car = Car(context: CoreDataStack.shared.context)
//    CarPlaceholderView(car: car)
//}
