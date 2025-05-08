//
//  PhoneSessionViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 17.03.2025.
//

import Foundation


class PhoneSessionViewModel: ObservableObject {
    
    private var phoneSession = PhoneSessionManager.shared
    private var db = CoreDataStack.shared
    private var repairService = RepairDataService()
    private var expenseObservationToken: NSObjectProtocol?
    private var carObservationToken: NSObjectProtocol?
    private var currentCar: Car?
    
    init() {
        expenseObservationToken = NotificationCenter.default.addObserver(
            forName: .didReceiveNewExpense,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.processPendingExpenses()
        }
        print("PhoneSessionViewModel: Подписка на .didReceiveNewExpense активирована")
        
        carObservationToken = NotificationCenter.default.addObserver(
            forName: .didChangeSelectedCar,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            if let newCar = notification.userInfo?["selectedCar"] as? Car {
                self?.setCurrentCar(car: newCar)
                print("PhoneSessionViewModel: значение selectedCar изменилось на \(String(describing: newCar.nameModel))")
            }}
        print("PhoneSessionViewModel: Подписка на .didChangeSelectedCar активирована")

    }
    
    deinit {
        if let expenseToken = expenseObservationToken {
            NotificationCenter.default.removeObserver(expenseToken)
            print("PhoneSessionViewModel: Отписка от .didReceiveNewExpense выполнена")
        }
        
        if let carToken = carObservationToken {
            NotificationCenter.default.removeObserver(carToken)
            print("PhoneSessionViewModel: Отписка от .didReceiveChangeName выполнена")

        }
    }
   
    func setCurrentCar(car: Car?) {
        self.currentCar = car
    }
    
    func processPendingExpenses() {
        print("processPendingExpenses() - is running...")
        let pendingExpenses = phoneSession.getPendingExpenses()
        
        guard !pendingExpenses.isEmpty else {
            print("Нет полученных трат от Apple Watch.")
            return
        }
        
        print("pendingExpenses.count: \(pendingExpenses.count)")
        if let car = currentCar {
            for expense in pendingExpenses {
                
                let result = repairService.creatingRepair(
                    repairDate: expense.dateOfRepair,
                    partReplaced: expense.nameRepair,
                    amount: expense.amount,
                    repairMileage: 0,
                    notes: "",
                    photoRepair: nil,
                    repairCategory: expense.category,
                    car: car,
                    partsDict: [:]
                )
                
                switch result {
                case .success():
                    print("Трата добавлена из Apple Watch в CoreData!")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
            print("Все траты обработаны, массив будет очищен.")
            phoneSession.clearPendingExpenses()
        } else {
            print("Автомобиль не выбран! Траты остаются в очереди.")
        }
    }
}
