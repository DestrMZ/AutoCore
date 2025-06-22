//
//  InsuranceService.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 13.06.2025.
//

import Foundation
import CoreData


final class InsuranceService {
    
    private let context = CoreDataStack.shared.context
    
    func createInsurance(car: Car?, type: String, nameCompany: String, startDate: Date, endDate: Date, price: Int32, notes: String?, notificationDate: Date?, isActive: Bool = true) -> Result<Void, InsuranceErrorStatus> {
        
        guard !nameCompany.isEmpty else { return .failure(.missingCompanyName)}
        guard price >= 0 else { return .failure(.invalidPriceAvaible )}
        guard startDate < endDate else { return .failure(.startDateAfterEndDate)}
        guard !type.isEmpty else { return .failure(.missingInsuranceType)}
        guard let car = car else { return .failure(.carNotAttached)}
        
        let insurance = Insurance(context: context)
        insurance.nameCompany = nameCompany
        insurance.type = type
        insurance.startDate = startDate
        insurance.endDate = endDate
        insurance.price = price
        insurance.notes = notes
        insurance.notificationDate = notificationDate
        insurance.isActive = isActive
        insurance.car = car
        
        print("Insurance created successfully")
        saveContext()
        return .success(())
    }
    
    func editingInsurance(for insurance: Insurance, type: String?, nameCompany: String?, startDate: Date?, endDate: Date?, price: Int32?, notes: String?, notificationDate: Date?, isActive: Bool = true) -> Result<Void, InsuranceErrorStatus> {
        
        guard insurance.car != nil else { return .failure(.carNotAttached)}
        guard let nameCompany = nameCompany, !nameCompany.isEmpty else { return .failure(.missingCompanyName)}
        guard let price = price, price >= 0 else { return .failure(.invalidPriceAvaible )}
        guard let startDate = startDate, let endDate = endDate, startDate < endDate else { return .failure(.startDateAfterEndDate)}
        guard let type = type, !type.isEmpty else { return .failure(.missingInsuranceType)}
        
        if let notificationDate = notificationDate {
            guard notificationDate > Date() else { return .failure(.notificationSetThePast)}
            insurance.notificationDate = notificationDate
        } else {
            insurance.notificationDate = nil
        }
        
        insurance.nameCompany = nameCompany
        insurance.type = type
        insurance.startDate = startDate
        insurance.endDate = endDate
        insurance.price = price
        insurance.notes = notes ?? insurance.notes
        insurance.isActive = isActive
        
        print("Insurance editing successfully")
        saveContext()
        return .success(())
    }
    
    func getAllInsurance(for car: Car) -> [Insurance] {
        let requestInsurance: NSFetchRequest<Insurance> = Insurance.fetchRequest()
        requestInsurance.predicate = NSPredicate(format: "car == %@", car)
        do {
            return try context.fetch(requestInsurance)
        } catch {
            print("WARNING: Failed to fetch insurance")
            return []
        }
    }
    
    func deleteInsurance(at insurance: Insurance) {
        context.delete(insurance)
        saveContext()
    }
    
    private func saveContext() {
        CoreDataStack.shared.saveContent()
    }
}
