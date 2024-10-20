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
