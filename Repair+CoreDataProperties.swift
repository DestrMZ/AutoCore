//
//  Repair+CoreDataProperties.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 12.10.2024.
//
//

import Foundation
import CoreData


extension Repair {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Repair> {
        return NSFetchRequest<Repair>(entityName: "Repair")
    }

    @NSManaged public var cost: Double
    @NSManaged public var nextServiceDate: Date?
    @NSManaged public var notes: String?
    @NSManaged public var partReplaced: String?
    @NSManaged public var repairDate: Date?
    @NSManaged public var repairMileage: Int32
    @NSManaged public var repairShop: String?
    @NSManaged public var photoRepair: Data?
    @NSManaged public var cars: Car?

}

extension Repair : Identifiable {

}
