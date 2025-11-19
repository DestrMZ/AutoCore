//
//  InsuranceViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 20.09.2025.
//

import Foundation
import Combine


@MainActor
final class InsuranceViewModel: ObservableObject {
    
    private let insuranceStore: InsuranceStore
    
    @Published private(set) var insurances: [InsuranceModel] = []
    @Published private(set) var selectedInsurance: InsuranceModel? = nil
    
    var type: String { selectedInsurance?.type ?? "" }
    var nameCompany: String { selectedInsurance?.nameCompany ?? "" }
    var startDate: Date { selectedInsurance?.startDate ?? Date() }
    var endDate: Date { selectedInsurance?.endDate ?? Date() }
    var price: Int32 { selectedInsurance?.price ?? 0 }
    var notes: String { selectedInsurance?.notes ?? "" }
    var notificationDate: Date? { selectedInsurance?.notificationDate }
    var isActive: Bool { selectedInsurance?.isActive ?? true }
        
    @Published var alertMessage: String = ""
    @Published var isShowAlert: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(insuranceStore: InsuranceStore) {
        self.insuranceStore = insuranceStore
        
        insuranceStore.$insurances
            .receive(on: RunLoop.main)
            .sink { [weak self] newInsurances in
                self?.insurances = newInsurances}
            .store(in: &cancellables)
        
        insuranceStore.$selectedInsurance
            .receive(on: RunLoop.main)
            .sink { [weak self] newInsurance in
                self?.selectedInsurance = newInsurance}
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: Error) {
        alertMessage = error.localizedDescription
        isShowAlert = true
    }
    
    func addInsurance(for car: CarModel, insurance: InsuranceModel) {
        do {
            try insuranceStore.addInsurance(for: car, insuranceModel: insurance)
        } catch {
            handleError(error)
        }
    }
    
    func updateInsurance(for car: CarModel, insurance: InsuranceModel) {
        do {
            try insuranceStore.updateInsurance(for: car, insuranceModel: insurance)
        } catch {
            handleError(error)
        }
    }
    
    func deleteInsurance(_ insurance: InsuranceModel) {
        do {
            try insuranceStore.deleteInsurance(insurance)
        } catch {
            handleError(error)
        }
    }
    
    func fetchAllInsurance(for car: CarModel) {
        do {
            try insuranceStore.loadInsurances(for: car)
        } catch {
            handleError(error)
        }
    }
    
    func selectInsurance(_ insurance: InsuranceModel?) {
        insuranceStore.selectInsurance(insurance)
    }
    
    func resetFields() {
        selectInsurance(nil)
    }
    
    func loadInsuranceInfo(from insurance: InsuranceModel) {
        selectInsurance(insurance)
    }
}
