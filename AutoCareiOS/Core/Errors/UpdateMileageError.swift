//
//  CarServiceError.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 02.05.2025.
//

import Foundation


enum UpdateMileageError: Error, LocalizedError {
    case carNotFound
    case invalidData
    case numberNonNegative
    case exceedsMaximumValue
    
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
        }
    }
}
