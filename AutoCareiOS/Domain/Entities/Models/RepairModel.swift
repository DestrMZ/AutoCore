//
//  RepairModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 15.06.2025.
//

import Foundation


struct RepairModel: Identifiable, Equatable {
    let id: UUID
    var amount: Int32
    var litresFuel: Double?
    var notes: String?
    var partReplaced: String
    var parts: [String: String]
    var photoRepairs: [Data]?
    var repairCategory: String
    var repairDate: Date
    var repairMileage: Int32
}
