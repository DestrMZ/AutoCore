//
//  Repair+CoreDataProperties.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 30.10.2024.
//
//

import Foundation
import CoreData


extension Repair {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Repair> {
        return NSFetchRequest<Repair>(entityName: "Repair")
    }

    @NSManaged public var amount: Int32
    @NSManaged public var notes: String?
    @NSManaged public var partReplaced: String?
    @NSManaged public var photoRepair: Data?
    @NSManaged public var repairCategory: String?
    @NSManaged public var repairDate: Date?
    @NSManaged public var repairMileage: Int32
    @NSManaged public var cars: Car?
    @NSManaged public var parts: NSSet?

}

// MARK: Generated accessors for parts
extension Repair {

    @objc(addPartsObject:)
    @NSManaged public func addToParts(_ value: Part)

    @objc(removePartsObject:)
    @NSManaged public func removeFromParts(_ value: Part)

    @objc(addParts:)
    @NSManaged public func addToParts(_ values: NSSet)

    @objc(removeParts:)
    @NSManaged public func removeFromParts(_ values: NSSet)

}

extension Repair : Identifiable {

}
