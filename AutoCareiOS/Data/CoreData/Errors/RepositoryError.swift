//
//  CarRepositoryError.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 16.06.2025.
//

import Foundation


enum RepositoryError: Error {
    case createFailed
    case fetchFailed
    case updateFailed
    case deleteFailed
    case objectNotFound
}
