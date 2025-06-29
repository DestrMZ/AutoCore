//
//  PhoneSessionManager.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 15.03.2025.
//

import WatchConnectivity
import CoreData
import Foundation
import Combine



class PhoneSessionRepository: NSObject {
     
    static var shared = PhoneSessionRepository()
    
    private let session: WCSession
    private(set) var pendingExpenses: [ExpensFromWatchOS] = []
    
    let newExpensesPublished = PassthroughSubject<[ExpensFromWatchOS], Never>()
    
    override init() {
        self.session = WCSession.default
        super.init()

        if WCSession.isSupported() {
            self.session.delegate = self
            self.session.activate()
            print("Устройство isSupported и активируется...")
        }
    }
    
    func appendExpenses(expense: ExpensFromWatchOS) {
        pendingExpenses.append(expense)
        newExpensesPublished.send(pendingExpenses)
    }
    
    func clearPendingExpenses() {
        pendingExpenses.removeAll()
    }
}

extension Notification.Name {
    static let didReceiveNewExpense = Notification.Name("didReceiveNewExpense")
}

extension PhoneSessionRepository: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            print("✅ iPhone активирован! Доступность: \(session.isReachable)")
        } else if let error = error {
            print("❌ Ошибка активации на iPhone: \(error.localizedDescription)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("🔄 Сессия стала неактивной")
        session.activate()
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Сессия деактивирована, повторная активация...")
        session.activate()
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any]) {
        print("📩 Получено пользовательское сообщение от Watch: \(userInfo)")
        
        guard let expenseData = userInfo["expense"] as? [String: Any] else { return }
    
        let nameRepair = expenseData["nameRepair"] as? String ?? "Unknown"
        let amount = expenseData["amount"] as? Int32 ?? 0
        let category = expenseData["category"] as? String ?? "service"
        let dateOfRepair = expenseData["dateOfRepair"] as? Date ?? Date()
        
        let expense = ExpensFromWatchOS(
            nameRepair: nameRepair,
            amount: amount,
            category: category,
            dateOfRepair: dateOfRepair
        )
        
        pendingExpenses.append(expense)
    }
}
