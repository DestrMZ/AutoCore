//
//  VinStore+CoreDataProperties.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 13.06.2025.
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
