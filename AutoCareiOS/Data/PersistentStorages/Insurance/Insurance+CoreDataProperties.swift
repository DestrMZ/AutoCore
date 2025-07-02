//
//  Insurance+CoreDataProperties.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 24.06.2025.
//
//

import Foundation
import CoreData


extension Insurance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Insurance> {
        return NSFetchRequest<Insurance>(entityName: "Insurance")
    }

    @NSManaged public var id: UUID
    @NSManaged public var type: String
    @NSManaged public var nameCompany: String
    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date
    @NSManaged public var price: Int32
    @NSManaged public var notes: String?
    @NSManaged public var notificationDate: Date?
    @NSManaged public var isActive: Bool
    @NSManaged public var car: Car?

}

extension Insurance : Identifiable {

}
