//
//  VinRepository.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 15.06.2025.
//

import Foundation
import CoreData


class VinRepository: VinRepositoryProtocol {
    
    private let context = CoreDataStack.shared.context
    
    func addVin(vin: String) -> Result<Void, VinRepositoryError> {
        let fetchRequest: NSFetchRequest<VinStore> = VinStore.fetchRequest()
       
        do {
            let vinStore = try context.fetch(fetchRequest).first ?? VinStore(context: context)
            
            var vinNumbers = vinStore.allVinNumbers ?? []
            
            guard !vinNumbers.contains(vin) else {
                return .failure(.vinAlreadyExists)}
            
            vinNumbers.append(vin)
            vinStore.allVinNumbers = vinNumbers
            
            try context.save()
            return .success(())
        } catch {
            debugPrint("WARNING: Failed to save context")
            return .failure(.createFailed)
        }
    }
    
    func getVins() -> Result<[String], VinRepositoryError> {
        let fetchRequest: NSFetchRequest<VinStore> = VinStore.fetchRequest()
        
        do {
            let vinNumbers = try context.fetch(fetchRequest)
            guard vinNumbers.first != nil else { return .failure(.vinNotFound)}
            
            let result = vinNumbers.first?.allVinNumbers ?? []
            return .success(result)
        } catch {
            debugPrint("WARNING: Error fetch VIN-Numbers")
            return .failure(.fetchFailed)
        }
    }
    
    func deleteVin(vin: String) -> Result<Void, VinRepositoryError> {
        let fetchRequest: NSFetchRequest<VinStore> = VinStore.fetchRequest()
        
        do {
            let vinNumbers = try context.fetch(fetchRequest)
            guard vinNumbers.first != nil else { return .failure(.vinNotFound)}
            guard let index = vinNumbers.first?.allVinNumbers?.firstIndex(of: vin) else { return .failure(.vinNotFound)}
            
            vinNumbers.first?.allVinNumbers?.remove(at: index)
            try context.save()
            return .success(())
        } catch {
            debugPrint("WARNING: Error delete VIN-Number")
            return .failure(.deleteFailed)
        }
    }
    
    func updateVin(oldVin: String, newVin: String) -> Result<Void, VinRepositoryError> {
        let fetchRequest: NSFetchRequest<VinStore> = VinStore.fetchRequest()
        
        do {
            guard let store = try context.fetch(fetchRequest).first else {
                return .failure(.vinNotFound)
            }
            
            guard var vinList = store.allVinNumbers else {
                return .failure(.vinNotFound)
            }
            
            guard let oldIndex = vinList.firstIndex(of: oldVin) else {
                return .failure(.updateFailed)
            }
            
            guard !vinList.contains(newVin) else {
                return .failure(.vinAlreadyExists)
            }
            
            vinList[oldIndex] = newVin
            store.allVinNumbers = vinList
            
            try context.save()
            return .success(())
            
        } catch {
            debugPrint("VinRepository: Failed to update VIN from \(oldVin) to \(newVin): \(error.localizedDescription)")
            return .failure(.updateFailed)
        }
    }
}


protocol VinRepositoryProtocol {
    func addVin(vin: String) -> Result<Void, VinRepositoryError>
    
    func getVins() -> Result<[String], VinRepositoryError>
    
    func deleteVin(vin: String) -> Result<Void, VinRepositoryError>
    
    func updateVin(oldVin: String, newVin: String) -> Result<Void, VinRepositoryError>
}
