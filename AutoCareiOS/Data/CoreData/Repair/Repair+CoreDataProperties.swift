//
//  Repair+CoreDataProperties.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 13.06.2025.
//
//

import Foundation
import CoreData


extension Repair {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Repair> {
        return NSFetchRequest<Repair>(entityName: "Repair")
    }

    @NSManaged public var id: UUID
    @NSManaged public var amount: Int32
    @NSManaged public var litresFuel: NSNumber?
    @NSManaged public var notes: String?
    @NSManaged public var partReplaced: String
    @NSManaged public var parts: [String: String]?
    @NSManaged public var photoRepair: [Data]?
    @NSManaged public var repairCategory: String
    @NSManaged public var repairDate: Date
    @NSManaged public var repairMileage: Int32
    @NSManaged public var car: Car?

}

extension Repair : Identifiable {

}
