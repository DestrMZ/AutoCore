//
//  SharedInsuranceStore.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 31.07.2025.
//

import Foundation


final class SharedInsuranceStore: ObservableObject {
    @Published var insurances: [InsuranceModel] = []
}
