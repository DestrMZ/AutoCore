//
//  VinStore+CoreDataProperties.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 15.11.2024.
//
//

import Foundation
import CoreData


extension VinStore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VinStore> {
        return NSFetchRequest<VinStore>(entityName: "VinStore")
    }

    @NSManaged public var allVinNumbers: [String]?

}

extension VinStore : Identifiable {

}
