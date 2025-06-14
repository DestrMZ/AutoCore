//
//  VinStoreService.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 20.04.2025.
//

import Foundation
import CoreData


final class VinStoreService {
    
    private let context = CoreDataStack.shared.context
    
    func addVin(vinNumber: String) {
        let requesVinStore: NSFetchRequest<VinStore> = VinStore.fetchRequest()
    
        let vinStore = try? context.fetch(requesVinStore).first ?? VinStore(context: context)
        
        var vinNumbers = vinStore?.allVinNumbers ?? []
        
        if !vinNumbers.contains(vinNumber) {
            vinNumbers.append(vinNumber)
            vinStore?.allVinNumbers = vinNumbers
        } else {
            print("INFO: Указанный VIN уже существует: \(vinNumber)")
        }
        
        saveContext()
    }
    
    func getAllVin() -> [String] {
        let requestVinNumbers: NSFetchRequest<VinStore> = VinStore.fetchRequest()
        do {
            let vinNumbers = try context.fetch(requestVinNumbers)
            if vinNumbers.first != nil {
                print("INFO: Все VIN: \(vinNumbers)")
                return vinNumbers.first?.allVinNumbers ?? []
            } else { return [] }
        } catch {
            print("WARNING: Ошибка при извлечении VIN-номеров: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteVin(_ vinNumber: String) {
        let requestVinNumber: NSFetchRequest<VinStore> = VinStore.fetchRequest()
        
        do {
            let vinStores = try context.fetch(requestVinNumber)
            
            if let vinStore = vinStores.first {
                if var _ = vinStore.allVinNumbers, let index = vinStore.allVinNumbers?.firstIndex(of: vinNumber) {
                    vinStore.allVinNumbers?.remove(at: index)
                    saveContext()
                    print("UPDATE: Новый массив \(String(describing: vinStore.allVinNumbers))")
                }
            }
        } catch {
            print("WARNING: Ошибка при удалении VIN-номера: \(error.localizedDescription)")
        }
    }
    
    func updateVin(oldVin: String, newVin: String) {
        let requestVinStore: NSFetchRequest<VinStore> = VinStore.fetchRequest()
        
        do {
            let vinStores = try context.fetch(requestVinStore)
            if let vinStore = vinStores.first, var vinNumbers = vinStore.allVinNumbers, let oldIndex = vinNumbers.firstIndex(of: oldVin) {
                
                guard !vinNumbers.contains(newVin) else {
                    print("WARNING: VIN '\(newVin)' уже существует.")
                    return
                }
                
                vinNumbers[oldIndex] = newVin
                vinStore.allVinNumbers = vinNumbers
                
                saveContext()
                print("INFO: VIN успешно изменён с \(oldVin) на \(newVin)")
            }
        } catch {
            print("ERROR: Ошибка при редактировании VIN: \(error.localizedDescription)")
        }
    }

    func saveContext() {
        CoreDataStack.shared.saveContent()
    }
}
