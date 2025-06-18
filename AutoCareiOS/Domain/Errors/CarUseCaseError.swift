//
//  CarServiceError.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 02.05.2025.
//

import Foundation


enum CarUseCaseError: Error, LocalizedError {
    case invalidData
    case duplicateVinNumber
    case missingNameModel
    case missingVinNumber
    case missingYear
    case missingMileage
    case carSaveFailed
    case getCarsFailed
    case deleteFailed
    case updateCarFailed
    
    var errorDescription: String? {
        switch self {
        case .duplicateVinNumber:
            return "Ops...that VIN number already exists."
        case .invalidData:
            return "Some data is invalid."
        case .missingNameModel:
            return "Please enter name and model."
        case .missingVinNumber:
            return "Please enter VIN number."
        case .missingYear:
            return "Please enter year."
        case .missingMileage:
            return "Please enter mileage."
        case .carSaveFailed:
            return "Car save failed."
        case .getCarsFailed:
            return "Get cars failed."
        case .deleteFailed:
            return "Delete failed."
        case .updateCarFailed:
            return "Update car failed."
        }
    }
}

enum CarUpdateError: Error, LocalizedError {
    case updateFailed
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Some data is invalid."
        case .updateFailed:
            return "Update failed."
        }
    }
}
