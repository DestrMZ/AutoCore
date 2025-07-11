//
//  CoreDataManaged.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 09.10.2024.
//

import Foundation
import CoreData
import PhotosUI


class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {
        persistentContainer.viewContext.mergePolicy = NSMergePolicy.error
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "carRepairApp")
        
        if let storeDescription = container.persistentStoreDescriptions.first {
            storeDescription.shouldMigrateStoreAutomatically = true
            storeDescription.shouldInferMappingModelAutomatically = true
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as? NSError {
                print("WARNING! COREDATASTACK: Ошибка загрузки Persistent Container: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContent() { // LEGACY
        let context = persistentContainer.viewContext
    
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("WARNING! COREDATASTACK: Ошибка сохранения: \(nsError), \(nsError.userInfo)")
        }
    }
}
