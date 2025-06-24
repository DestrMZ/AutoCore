//
//  InsuranceErrorStatus.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 13.06.2025.
//

import Foundation

enum InsuranceError: Error, LocalizedError {

    // MARK: - Валидация
    
    case missingCompanyName
    case missingInsuranceType
    case invalidPrice
    case startDateAfterEndDate
    case endDateInPast
    case notificationSetInPast
    case carNotFound
    case insuranceNotFound

    // MARK: - Хранилище
    
    case saveFailed
    case fetchFailed
    case updateFailed
    case deleteFailed
    case createFailed

    // MARK: - Описание для UI

    var errorDescription: String? {
        switch self {
            
        // Валидация
        case .missingCompanyName:
            return "Insurance company is required."
        case .missingInsuranceType:
            return "Insurance type is required."
        case .invalidPrice:
            return "Insurance price must be greater than zero."
        case .startDateAfterEndDate:
            return "Start date must be earlier than end date."
        case .endDateInPast:
            return "End date cannot be in the past."
        case .notificationSetInPast:
            return "Notification date cannot be set in the past."
        case .carNotAttached:
            return "No car is associated with this insurance."

        // Ошибки хранилища
        case .saveFailed:
            return "Failed to save insurance."
        case .fetchFailed:
            return "Failed to fetch insurances."
        case .updateFailed:
            return "Failed to update insurance."
        case .deleteFailed:
            return "Failed to delete insurance."
        case .createFailed:
            return "Failed to create insurance."
        case .insuranceNotFound:
            return "Insurance not found."
        }
    }
}
