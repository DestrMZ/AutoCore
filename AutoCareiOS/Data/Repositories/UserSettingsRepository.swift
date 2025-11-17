//
//  UserSettingsRepository.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 25.06.2025.
//

import Foundation


class UserStoreRepository: UserStoreRepositoryProtocol {

    func saveLastSelectedVin(_ vin: String) {
        UserDefaults.standard.set(vin, forKey: "currentAuto")
        debugPrint("[UserSettingsRepository] Save last selected vin: \(vin)")
    }

    func loadLastSelectedVin() -> String? {
        UserDefaults.standard.string(forKey: "currentAuto")
    }
}


protocol UserStoreRepositoryProtocol {
    func saveLastSelectedVin(_ vin: String)
    
    func loadLastSelectedVin() -> String?
}
