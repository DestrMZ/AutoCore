////
////  WatchSessionManager.swift
////  AutoCareWatchOS
////
////  Created by Ivan Maslennikov on 15.03.2025.
////
//
//import Foundation
//import WatchConnectivity
//
//class WatchSessionRepository: NSObject {
//
//    static let shared = WatchSessionRepository()
//    
//    private let session: WCSession
//    
//    override init() {
//        self.session = WCSession.default
//        super.init()
//        session.delegate = self
//        session.activate()
//    }
//    
//    func sendExpense(_ expense: ExpensWatchOS) {
//        guard session.isReachable else {
//            print("iPhone не доступен")
//            return
//        }
//        
//        let expenseData: [String: Any] = [
//            "nameRepair": expense.nameRepair,
//            "amount": expense.amount,
//            "category": expense.category,
//            "dateOfRepair": expense.dateOfRepair
//        ]
//        
//        do {
//            let userInfo = ["expense": expenseData]
//            let transfer = WCSession.default.transferUserInfo(userInfo)
//            print("📤 Данные отправлены в очередь: \(expense.nameRepair), \(expense.amount), \(expense.category), \(expense.dateOfRepair)")
//            print("📦 Статус передачи: \(transfer.isTransferring ? "В процессе" : "Не начата")")
//        }
//    }
//}
//
//extension WatchSessionRepository: WCSessionDelegate {
//    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
//        guard let carsArray = applicationContext["cars"] as? [[String: String]] else {
//            print("Не удалось распарсить массив машин")
//            return
//        }
//        
//        let cars = carsArray.compactMap { dict -> CarFromiOS? in
//            guard
//                let idStr = dict["id"], let id = UUID(uuidString: idStr),
//                let name = dict["nameModel"],
//                let photoBase64 = dict["photo"],
//                let photoData = Data(base64Encoded: photoBase64)
//            else { return nil }
//            
//            return CarFromiOS(id: id, nameModel: name, photo: photoData)
//        }
//    }
//    
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        if activationState == .activated {
//            print("Сессия активирована")
//        } else if let error = error {
//            print("Ошибка активации: \(error.localizedDescription)")
//        }
//    }
//    
//    func sessionReachabilityDidChange(_ session: WCSession) {
//        print("iPhone доступен: \(session.isReachable)")
//    }
//    
//    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
//        if let error = error {
//            print("Ошибка завершения передачи - \(error.localizedDescription)")
//        } else {
//            print("Передача успешно завернешена!")
//        }
//    }
//}
