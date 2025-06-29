//
//  WatchSyncViewModel.swift
//  AutoCareWatchOS
//
//  Created by Ivan Maslennikov on 11.03.2025.
//

import Foundation
import WatchConnectivity
import SwiftUI

class ExpensesViewModel: ObservableObject {
    
//    @Published var car:
    @Published var nameRepair: String = ""
    @Published var amount: Int32 = 0
    @Published var category: RepairCategoryForWatchOS = .service
    @Published var isCompited: Bool = false
    @Published var navigationPath: NavigationPath = NavigationPath()
    
    private let sessionWatchManager = WatchSessionManager.shared
    
    func resetField() {
        self.nameRepair = ""
        self.amount = 0
        self.category = .service
        self.isCompited = false
        self.navigationPath = NavigationPath()
    }
    
    func saveRepair() {
        guard amount > 0, !nameRepair.isEmpty else { return }
        
        let finalyExpense = ExpensWatchOS(
            nameRepair: nameRepair,
            amount: amount,
            category: category.rawValue)
        
        sessionWatchManager.sendExpense(finalyExpense)
    }
    
}
