//
//  InsuranceModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 15.06.2025.
//

import Foundation


struct InsuranceModel: Identifiable, Equatable {
    let id: UUID
    var type: String
    var nameCompany: String
    var startDate: Date
    var endDate: Date
    var price: Int32
    var notes: String?
    var notificationDate: Date?
    var isActive: Bool
}
