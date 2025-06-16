//
//  CarRepositoryError.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 16.06.2025.
//

import Foundation


enum CarRepositoryError: Error {
    case creationFailed
    case fetchFailed
    case updateFailed
    case deleteFailed
    case carNotFound
    case updateMileageFailed
}
