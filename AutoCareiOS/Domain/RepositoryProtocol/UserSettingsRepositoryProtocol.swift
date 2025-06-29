//
//  UserSettingsRepositoryProtocol.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 29.06.2025.
//

import Foundation


protocol UserStoreRepositoryProtocol {
    func saveLastSelectedVin(_ vin: String)
    func loadLastSelectedVin() -> String?
}
