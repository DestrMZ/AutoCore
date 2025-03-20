//
//  UtilityFunctions.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 12.10.2024.
//

import Foundation
import UIKit

/// Проверяет, является ли форма добавления автомобиля валидной.
/// - Parameter carViewModel: Экземпляр `CarViewModel`, содержащий данные об автомобиле.
/// - Returns: Булево значение, указывающее, заполнены ли все необходимые поля.
func isFormIncomplete(nameModel: String, vinNumber: String, year: Int16?, mileage: Int32?) -> Bool {
    return nameModel.isEmpty || vinNumber.isEmpty || (year ?? 0) <= 0 || (mileage ?? 0) <= 0
}

/// Возвращает настроенный форматтер для ввода года.
/// - Returns: Объект `NumberFormatter` с числовым стилем и без дробных значений.
func yearFormatter() -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .none
    formatter.maximumFractionDigits = 4
    return formatter
}

/// Возвращает форматтер для ввода пробега.
/// - Returns: Объект `NumberFormatter` с настройками для ввода целых чисел без разделителя тысяч.
func mileageFormatter() -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.isLenient = true
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.usesGroupingSeparator = false
    return formatter
}

/// Возвращает форматтер для отображения даты в коротком формате.
/// - Returns: Объект `DateFormatter` с настройкой стиля даты на `medium`.
func dateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}

/// Возвращает форматтер для отображения цены.
/// - Returns: Объект `NumberFormatter` с десятичным стилем и без дробных значений.
func numberFormatterForCoast() -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.isLenient = true
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    // formatter.positiveSuffix = " RUB"
    return formatter
}

/// Возвращает форматтер для отображения пробега.
/// - Returns: Объект `NumberFormatter` с настройкой для целых чисел без разделителя тысяч.
func numberFormatterForMileage() -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.isLenient = true
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.usesGroupingSeparator = false
    // formatter.positiveSuffix = " KM"
    return formatter
}

/// Копирует переданный текст в буфер обмена.
/// - Parameter text: Текст, который нужно скопировать в буфер обмена.
func copyToClipboard(text: String) {
    UIPasteboard.general.string = text
    print("INFO: \(text) скопирован в буфер обмена")
}

/// Выполняет тактильную отдачу (haptic feedback) с тяжелым стилем.
func provideHapticFeedback() {
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    impactFeedbackGenerator.prepare()
    impactFeedbackGenerator.impactOccurred()
}

/// Ограничивает значение количества до заданного диапазона (0–10 000 000).
/// - Parameter amount: Проверяемое значение количества.
/// - Returns: Значение, находящееся в допустимом диапазоне.
func validForAmount(_ amount: Int32) -> Int32 {
    if amount < 0 || amount > 10_000_000 {
        return 10_000_000
    } else {
        return amount
    }
}

/// Ограничивает значение пробега до заданного диапазона (0–1 000 000).
/// - Parameter mileage: Проверяемое значение пробега.
/// - Returns: Значение пробега в пределах допустимого диапазона.
func validForMileage(_ mileage: Int32) -> Int32 {
    if mileage <= 0 || mileage > 1_000_000 {
        return 1_000_000
    } else {
        return mileage
    }
}

func validForYear(_ year: Int16) -> Int16 {
    let currentYear = Calendar.current.component(.year, from: Date())
    
    if year <= 0 || year > currentYear {
        return Int16(currentYear)
    } else {
        return year
    }
}

func percentFormatter() -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.maximumFractionDigits = 1
    formatter.multiplier = 1
    return formatter
}

func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
