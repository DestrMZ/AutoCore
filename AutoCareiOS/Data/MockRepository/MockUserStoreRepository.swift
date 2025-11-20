//
//  MockUserStoreRepository.swift
//  AutoCareiOSTests
//
//  Created by Ivan Maslennikov on 20.11.2025.
//

import Foundation


final class MockUserStoreRepository: UserStoreRepositoryProtocol {
    var lastSelectedVin: String?

    func saveLastSelectedVin(_ vin: String) {
        lastSelectedVin = vin
    }

    func loadLastSelectedVin() -> String? {
        return lastSelectedVin
    }
}
