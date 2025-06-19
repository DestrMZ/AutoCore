//
//  CarServiceError.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 02.05.2025.
//

import Foundation


enum CarValidationError: LocalizedError {
    case missingNameModel
    case missingVinNumber
    case missingYear
    case missingMileage
    case duplicateVinNumber

    var errorDescription: String? {
        switch self {
        case .missingNameModel: return "Please enter name and model."
        case .missingVinNumber: return "Please enter VIN number."
        case .missingYear: return "Please enter year."
        case .missingMileage: return "Please enter mileage."
        case .duplicateVinNumber: return "Ops...that VIN number already exists."
        }
    }
}


enum CarStorageError: Error, LocalizedError {
    case saveFailed
    case fetchFailed
    case deleteFailed
    case updateFailed
    case vinNumberSaveFailed

    var errorDescription: String? {
        switch self {
        case .saveFailed: return "Car save failed."
        case .fetchFailed: return "Failed to fetch cars."
        case .deleteFailed: return "Failed to delete car."
        case .updateFailed: return "Failed to update car."
        case .vinNumberSaveFailed: return "Failed to save VIN number."
        }
    }
}


enum UpdateMileageUseCaseError: Error, LocalizedError {
    case carNotFound
    case invalidData
    case numberNonNegative
    case exceedsMaximumValue
    case updateMileageFailed
    
    var errorDescription: String? {
        switch self {
        case .carNotFound:
            return NSLocalizedString("Car not found.", comment: "")
        case .invalidData:
            return NSLocalizedString("Some data is invalid.", comment: "")
        case .numberNonNegative:
            return NSLocalizedString("Mileage must be non-negative.", comment: "")
        case .exceedsMaximumValue:
            return NSLocalizedString("Mileage exceeds maximum value.", comment: "")
        case .updateMileageFailed:
            return NSLocalizedString("Failed to update mileage.", comment: "")
        }
    }
}
