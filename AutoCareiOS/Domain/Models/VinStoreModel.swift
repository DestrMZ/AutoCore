//
//  VinStoreModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 15.06.2025.
//

import Foundation


struct VinStoreModel: Identifiable, Equatable {
    let id: UUID
    let allVinNumbers: [String]?
}
