//
//  Car+CoreDataProperties.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 07.11.2024.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var color: String?
    @NSManaged public var engineType: String?
    @NSManaged public var mileage: Int32
    @NSManaged public var nameModel: String?
    @NSManaged public var photoCar: Data?
    @NSManaged public var transmissionType: String?
    @NSManaged public var vinNumber: String?
    @NSManaged public var year: Int16
    @NSManaged public var repairs: NSSet?

}

// MARK: Generated accessors for repairs
extension Car {

    @objc(addRepairsObject:)
    @NSManaged public func addToRepairs(_ value: Repair)

    @objc(removeRepairsObject:)
    @NSManaged public func removeFromRepairs(_ value: Repair)

    @objc(addRepairs:)
    @NSManaged public func addToRepairs(_ values: NSSet)

    @objc(removeRepairs:)
    @NSManaged public func removeFromRepairs(_ values: NSSet)

}

extension Car : Identifiable {

}
