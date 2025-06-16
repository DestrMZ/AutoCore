//
//  ImageMapper.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 04.05.2025.
//

import Foundation
import UIKit


struct ImageMapper {
    
    static func convertToData(images: [UIImage]?) -> [Data] {
        guard let dataArray = images else { return [] }
        return dataArray.compactMap { $0.jpegData(compressionQuality: 1.0 ) }
    }
    
    static func convertToUIImage(images: [Data]?) -> [UIImage] {
        guard let dataArray = images else { return [] }
        return dataArray.compactMap { UIImage(data: $0) }
    }
    
    static func convertSingleToData(image: UIImage?) -> Data? {
        guard let data = image else { return nil }
        return data.jpegData(compressionQuality: 1.0)
    }
    
    static func convertSingleToUIImage(image: Data?) -> UIImage? {
        guard let image = image else { return nil }
        return UIImage(data: image)
    }
}
