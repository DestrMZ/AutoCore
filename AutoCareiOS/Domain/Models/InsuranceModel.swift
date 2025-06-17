//
//  InsuranceModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 15.06.2025.
//

import Foundation


struct InsuranceModel: Identifiable, Equatable {
    let id: UUID
    let type: String
    let nameCompany: String
    let startDate: Date
    let endDate: Date
    let price: Int32
    let notes: String?
    let notificationDate: Date?
    let isActive: Bool
}
