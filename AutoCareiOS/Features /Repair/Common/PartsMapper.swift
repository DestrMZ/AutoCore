//
//  Service.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 21.04.2025.
//

import Foundation
import UIKit


struct PartMappers {
    
    static func fromDictionary(_ dict: [String: String]) -> [Part] {
        dict.map { Part(article: $0.key, name: $0.value) }
    }
    
    static func toDictionary(_ parts: [Part]) -> [String: String] {
        var result: [String: String] = [:]
        for part in parts {
            let trimmedKey = part.article.trimmingCharacters(in: .whitespaces)
            let trimmedValue = part.name.trimmingCharacters(in: .whitespaces)
            if !trimmedKey.isEmpty || !trimmedValue.isEmpty {
                result[trimmedKey] = trimmedValue
            }
        }
        return result
    }
}


func conversionPhotoRepair(at repair: Repair) -> [UIImage] {
    var imageRepair: [UIImage] = []
    
    if let dataPhotoRepair = repair.photoRepair {
        for data in dataPhotoRepair {
            if let image = UIImage(data: data) {
                imageRepair.append(image)
            }
        }
    }
    return imageRepair
}
