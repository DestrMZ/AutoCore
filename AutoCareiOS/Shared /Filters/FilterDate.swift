//
//  FilterDate.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 23.06.2025.
//

import Foundation


enum FilterDate: Hashable {
    case allTime
    case week
    case month
    case year
    case custom(startDate: Date, endDate: Date)
}
