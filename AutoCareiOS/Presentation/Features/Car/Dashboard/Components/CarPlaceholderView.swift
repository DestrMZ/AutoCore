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
    
    private var carImage: UIImage {
        car.photoCar.flatMap(UIImage.init) ?? imagePlaceHolder
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(uiImage: carImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                
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


#Preview {
    CarPlaceholderView(
        car: CarModel(
            id: UUID(),
            nameModel: "Hyundai Solaris",
            year: 2021,
            color: "Серебристый металлик",
            engineType: EngineTypeEnum.gasoline.rawValue,
            transmissionType: TransmissionTypeEnum.automatic.rawValue,
            mileage: 87_420,
            photoCar: nil,
            vinNumbers: "Z94K241CBMR123456",
            stateNumber: "A777AA77"
        )
    )
}
