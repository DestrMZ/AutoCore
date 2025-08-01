//
//  SharedRepairStore.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 30.07.2025.
//

import Foundation


final class SharedRepairStore: ObservableObject {
    @Published var repairs: [RepairModel] = []
}
