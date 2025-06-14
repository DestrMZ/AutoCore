//
//  RepairGroup.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 21.05.2025.
//

import Foundation


struct RepairGroup: Identifiable {
    let id = UUID()
    let monthTitle: String
    let repairs: [Repair]
    let totalAmount: Double
}
