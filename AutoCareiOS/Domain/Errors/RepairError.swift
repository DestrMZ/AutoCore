//
//  RepairError.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 23.06.2025.
//

import Foundation

enum RepairError: Error, LocalizedError {
    
    // MARK: - Валидация
    
    case missingTitle
    case missingAmount
    case missingMileage
    case invalidAmountFormat
    case invalidMileageFormat
    case mileageExceedsLimit
    case tooManyPhotos
    case invalidPartDescription
    
    // MARK: - Работа с хранилищем
    
    case repairNotFound
    case carNotFound
    case saveFailed
    case fetchFailed
    case updateFailed
    case deleteFailed
    case createFailed
    
    // MARK: - Описание ошибки для UI
    
    var errorDescription: String? {
        switch self {
            
        // Валидация
        case .missingTitle:
            return "Please enter the name of the repair or part replaced."
        case .missingAmount:
            return "Please enter the amount spent on the repair."
        case .missingMileage:
            return "Please enter the mileage at which the repair was made."
        case .invalidAmountFormat:
            return "Repair amount must be a valid number."
        case .invalidMileageFormat:
            return "Mileage must be a valid number."
        case .mileageExceedsLimit:
            return "Mileage exceeds realistic limit (5,000,000)."
        case .tooManyPhotos:
            return "You can upload up to 10 photos."
        case .invalidPartDescription:
            return "Check the specified parts, the fields should not be empty"
            
        // CoreData ошибки
        case .repairNotFound:
            return "Repair not found in the database."
        case .carNotFound:
            return "Car not found for this repair."
        case .saveFailed:
            return "Failed to save repair."
        case .fetchFailed:
            return "Failed to load repairs."
        case .updateFailed:
            return "Failed to update repair."
        case .deleteFailed:
            return "Failed to delete repair."
        case .createFailed:
            return "Failed to create repair."
        }
    }
}
