//
//  ExpenseStep.swift
//  AutoCareWatchOS
//
//  Created by Ivan Maslennikov on 20.03.2025.
//

import Foundation


enum ExpenseStep: Hashable {
    case enterTitle
    case enterAmount
    case selectCategory
    case confirm
    case successfull
}
