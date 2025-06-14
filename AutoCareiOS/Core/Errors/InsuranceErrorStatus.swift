//
//  InsuranceErrorStatus.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 13.06.2025.
//

import Foundation


enum InsuranceErrorStatus: Error, LocalizedError {
    case invalidPriceAvaible
    case startDateAfterEndDate
    case notificationDateInPast
    case missingCompanyName
    case missingInsuranceType
    case endDateInPast
    case carNotAttached
    case notificationSetThePast

    var errorDescription: String? {
        switch self {
        case .invalidPriceAvaible:
            return "Insurance price is not available"
        case .startDateAfterEndDate:
            return "Start date must be before end date"
        case .notificationDateInPast:
            return "Notification date cannot be in the past"
        case .missingCompanyName:
            return "Insurance company is required"
        case .missingInsuranceType:
            return "Insurance type is required"
        case .endDateInPast:
            return "End date cannot be earlier than today"
        case .carNotAttached:
            return "No car is associated with this insurance"
        case .notificationSetThePast:
            return "Notification date cannot be in the past"
        }
    }
}
