//
//  UtilityFunctions.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 12.10.2024.
//

import Foundation
import UIKit

func isValidForm(carViewModel: CarViewModel) -> Bool {
    
    return
        !carViewModel.nameModel.isEmpty &&
        !carViewModel.vinNumber.isEmpty &&
        !carViewModel.color.isEmpty &&
        !carViewModel.engineType.rawValue.isEmpty &&
        !carViewModel.transmissionType.rawValue.isEmpty &&
        carViewModel.year > 0 &&
        carViewModel.mileage > 0
    
}

func dateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
    }

func numberFormatterForCoast() -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.isLenient = true
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.positiveSuffix = " RUB"
    return formatter
    }

func numberFormatterForMileage() -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.isLenient = true
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.usesGroupingSeparator = false
    formatter.positiveSuffix = " KM"
    return formatter
}

func copyToClipboard(text: String) {
    UIPasteboard.general.string = text
    print("INFO: \(text) скопирован в буфер обмена")

}

func provideHapticFeedback() {
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    impactFeedbackGenerator.prepare()
    impactFeedbackGenerator.impactOccurred()
}

func validForAmount(_ amount: Int32) -> Int32 {
    if amount < 0 || amount > 10_000_000 {
        return 1_000_000
    } else {
        return amount
    }
}


func validForMileage(_ mileage: Int32) -> Int32 {
    if mileage < 0 || mileage > 1_000_000 {
        return 1_000_000
    } else {
        return mileage
    }
}
