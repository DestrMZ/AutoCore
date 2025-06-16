//
//  Car+CoreDataProperties.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 13.06.2025.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var id: UUID
    @NSManaged public var color: String?
    @NSManaged public var engineType: String
    @NSManaged public var existingVinNumbers: [String]?
    @NSManaged public var mileage: Int32
    @NSManaged public var nameModel: String
    @NSManaged public var photoCar: Data
    @NSManaged public var stateNumber: String?
    @NSManaged public var transmissionType: String
    @NSManaged public var vinNumber: String
    @NSManaged public var year: Int16
    @NSManaged public var repairs: NSSet?
    @NSManaged public var insurance: NSSet?

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

// MARK: Generated accessors for insurance
extension Car {

    @objc(addInsuranceObject:)
    @NSManaged public func addToInsurance(_ value: Insurance)

    @objc(removeInsuranceObject:)
    @NSManaged public func removeFromInsurance(_ value: Insurance)

    @objc(addInsurance:)
    @NSManaged public func addToInsurance(_ values: NSSet)

    @objc(removeInsurance:)
    @NSManaged public func removeFromInsurance(_ values: NSSet)

}

extension Car : Identifiable {

}
