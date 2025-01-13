//
//  EnumModel.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 13.10.2024.
//

import Foundation


enum EngineTypeEnum: String, CaseIterable  {
    
    case diesel = "Diesel"
    case gasoline = "Gasoline"
    case hybrid = "Hybrid"
    case electric = "Electric"
}


enum TransmissionTypeEnum: String, CaseIterable {
    
    case automatic = "Automatic"
    case manual = "Manual"
    case robotized = "Robotized"
    case variator = "Variator"
}

// TODO: Add type car
enum TypeCar: String, CaseIterable {
    
    case sedan = "Sedan"
    case coupe = "Coupe"
    case hatchback = "Hatchback"
    case liftback = "Liftback"
    case fastback = "Fastback"
    case station = "Station"
    case crossover = "Crossover"
    case SUV = "SUV (full-size crossover)"
    case pickup = "Pickup"
    case passengerVan = "Passenger van"
    case minivan = "Minivan"
    case microvan = "Microvan"
}


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


enum FilterDate: Hashable {
    case allTime
    case week
    case month
    case year
    case custom(startDate: Date, endDate: Date)
}
