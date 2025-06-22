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
    
    func addVin(vin: String) throws {
        let fetchRequest: NSFetchRequest<VinStore> = VinStore.fetchRequest()
       
        do {
            let vinStore = try context.fetch(fetchRequest).first ?? VinStore(context: context)
            
            var vinNumbers = vinStore.allVinNumbers ?? []
            
            vinNumbers.append(vin)
            vinStore.allVinNumbers = vinNumbers
            
            try context.save()
        } catch {
            debugPrint("[VinRepository]: Failed to save context: \(error.localizedDescription).")
            throw RepositoryError.createFailed
        }
    }
    
    func getVins() throws -> [String] {
        let fetchRequest: NSFetchRequest<VinStore> = VinStore.fetchRequest()
        
        do {
            guard let store = try context.fetch(fetchRequest).first else {
                return []
            }
            
            return store.allVinNumbers ?? []
        } catch {
            debugPrint("[VinRepository] Error fetch VIN-Numbers: \(error.localizedDescription).")
            throw RepositoryError.fetchFailed
        }
    }
    
    func updateVin(oldVin: String, newVin: String) throws {
        let fetchRequest: NSFetchRequest<VinStore> = VinStore.fetchRequest()
        
        do {
            guard let store = try context.fetch(fetchRequest).first,
                  var list = store.allVinNumbers,
                  let index = list.firstIndex(of: oldVin) else {
                return
            }
            list[index] = newVin
            store.allVinNumbers = list
            try context.save()
        } catch {
            debugPrint("[VinRepository] Failed to update VIN from \(oldVin) to \(newVin): \(error.localizedDescription).")
            throw RepositoryError.updateFailed
        }
    }
    
    func deleteVin(vin: String) throws {
        let fetchRequest: NSFetchRequest<VinStore> = VinStore.fetchRequest()
        
        do {
            guard let store = try context.fetch(fetchRequest).first,
                  var list = store.allVinNumbers,
                  let index = list.firstIndex(of: vin) else {
                return
            }
            list.remove(at: index)
            store.allVinNumbers = list
            try context.save()
        } catch {
            debugPrint("[VinRepository] Error delete VIN-Number: \(error.localizedDescription).")
            throw RepositoryError.deleteFailed
        }
    }
}


protocol VinRepositoryProtocol {
    func addVin(vin: String) throws
    
    func getVins() throws -> [String]
    
    func deleteVin(vin: String) throws
    
    func updateVin(oldVin: String, newVin: String) throws
}
