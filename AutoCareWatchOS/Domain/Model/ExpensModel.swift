//
//  ExpensesModel.swift
//  AutoCareWatchOS
//
//  Created by Ivan Maslennikov on 11.03.2025.
//

import Foundation


struct ExpensWatchOS {
//    var car: CarModel
    var nameRepair: String
    var amount: Int32
    var category: String
    var dateOfRepair: Date = Date()
}


enum RepairCategoryForWatchOS: String, CaseIterable, Hashable {
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
