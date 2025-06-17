//
//  RepairModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 15.06.2025.
//

import Foundation


struct RepairModel: Identifiable, Equatable {
    let id: UUID
    let amount: Int32
    let litresFuel: Double?
    let notes: String?
    let partReplaced: String
    let parts: [String: String]
    let photoRepairs: [Data]?
    let repairCategory: String
    let repairDate: Date
    let repairMileage: Int32
}
