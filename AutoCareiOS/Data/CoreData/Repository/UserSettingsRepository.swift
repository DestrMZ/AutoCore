//
//  UserSettingsRepository.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 25.06.2025.
//

import Foundation


class UserSettingsRepository: UserSettingsRepositoryProtocol {
    
    func saveLastSelectedVin(_ vin: String) {
        UserDefaults.standard.set(vin, forKey: "currentAuto")
        debugPrint("[UserSettingsRepository] Save last selected vin: \(vin)")
    }
    
    func loadLastSelectedVin() -> String? {
        UserDefaults.standard.string(forKey: "currentAuto")
    }
}


protocol UserSettingsRepositoryProtocol {
    func saveLastSelectedVin(_ vin: String)
    func loadLastSelectedVin() -> String?
}
