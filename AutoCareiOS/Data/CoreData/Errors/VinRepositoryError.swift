//
//  VinRepositoryError.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 16.06.2025.
//

import Foundation


enum VinRepositoryError: Error {
    case fetchFailed
    case createFailed
    case vinAlreadyExists
    case vinNotFound
    case updateFailed
    case deleteFailed
}
