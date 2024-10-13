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
