//
//  SharedInsuranceStore.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 31.07.2025.
//

import Foundation


final class SharedInsuranceStore: ObservableObject {
    @Published var insurances: [InsuranceModel] = []
    
    func addInsurance(_ insurance: InsuranceModel) {
        insurances.append(insurance)
    }
    
    func deleteInsurance(_ insurance: InsuranceModel) {
        if let index = insurances.firstIndex(where: { $0.id == insurance.id }) {
            insurances.remove(at: index)
        }
    }
}
