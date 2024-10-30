//
//  Part+CoreDataProperties.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 30.10.2024.
//
//

import Foundation
import CoreData


extension Part {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Part> {
        return NSFetchRequest<Part>(entityName: "Part")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var namePart: String?
    @NSManaged public var article: String?
    @NSManaged public var partRepair: Repair?

}

extension Part : Identifiable {

}
