//
//  CarError.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 02.05.2025.
//

import Foundation

enum CarError: Error, LocalizedError {
    
    // MARK:  Валидация
    
    case missingNameModel
    case missingVinNumber
    case missingYear
    case missingMileage
    case duplicateVinNumber
    
    // MARK: - Работа с хранилищем
    
    case saveFailed
    case fetchFailed
    case deleteFailed
    case updateFailed
    case vinNumberSaveFailed
    
    // MARK: - Пробег
    
    case carNotFound
    case invalidMileageData
    case mileageNegative
    case mileageExceedsLimit
    case mileageUpdateFailed

    // MARK: - Description для UI
    
    var errorDescription: String? {
        switch self {
            
        // Валидация
        case .missingNameModel:
            return "Please enter name and model."
        case .missingVinNumber:
            return "Please enter VIN number."
        case .missingYear:
            return "Please enter year."
        case .missingMileage:
            return "Please enter mileage."
        case .duplicateVinNumber:
            return "Oops... that VIN number already exists."
            
        // CoreData ошибки
        case .saveFailed:
            return "Failed to save car."
        case .fetchFailed:
            return "Failed to load cars."
        case .deleteFailed:
            return "Failed to delete car."
        case .updateFailed:
            return "Failed to update car."
        case .vinNumberSaveFailed:
            return "Failed to save VIN number."
            
        // Пробег
        case .carNotFound:
            return "Car not found."
        case .invalidMileageData:
            return "Invalid mileage data."
        case .mileageNegative:
            return "Mileage must be greater than 0."
        case .mileageExceedsLimit:
            return "Mileage exceeds realistic limit."
        case .mileageUpdateFailed:
            return "Failed to update mileage."
        }
    }
}
