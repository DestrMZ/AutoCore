//
//  RepairServiceError.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 02.05.2025.
//

import Foundation


enum RepairErrorStatus: Error, LocalizedError {
    case repairNotFound
    case missingPartReplaced
    case invalidAmount
    case invalidMileage
    case carNotFound
    
    var errorDescription: String? {
        switch self {
        case .missingPartReplaced:
            return "Part Replaced field is required"
        case .invalidAmount:
            return "Amount must be a number"
        case .invalidMileage:
            return "Mileage must be a number"
        case .repairNotFound:
            return "Repair not found in database"
        case .carNotFound:
            return "Car not found in database"
        }
    }
}

