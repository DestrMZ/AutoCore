//
//  RepairCategory.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 23.06.2025.
//

import Foundation


enum RepairCategory: String, CaseIterable {
    case service = "Service"
    case fuel = "Fuel"
    case wash = "Washing"
    case parking = "Parking"
    case insurance = "Insurance"
    case other = "Other"
    
    var imageIcon: String {
        switch self {
        case .service:
            return "image_service"
        case .fuel:
            return "image_fuel"
        case .wash:
            return "image_wash"
        case .parking:
            return "image_parking"
        case .insurance:
            return "image_insurance"
        case .other:
            return "image_other"
        }
    }
}
