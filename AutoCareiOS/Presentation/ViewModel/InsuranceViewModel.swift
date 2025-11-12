//
//  InsuranceViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 20.09.2025.
//


import Foundation


class InsuranceViewModel: ObservableObject {
    
    private let insuranceUseCase: InsuranceUseCaseProtocol
    
    init(insuranceUseCase: InsuranceUseCaseProtocol) {
        self.insuranceUseCase = insuranceUseCase
    }
    
    @Published var type: String = ""
    @Published var nameCompany: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var price: Int32 = 0
    @Published var notes: String = ""
    @Published var notificationDate: Date? = nil
    @Published var isActive: Bool = true
    
    @Published var insurances: [InsuranceModel] = []
    @Published var alertMessage: String = ""
    @Published var alertShow: Bool = false
    
    @Published var selectedInsurance: InsuranceModel? = nil
    
    func addInsurance(for carModel: CarModel, with insuranceModel: InsuranceModel) {
        do {
            let insurance = try insuranceUseCase.createInsurance(for: carModel, with: insuranceModel)
            self.insurances.append(insurance)
        } catch {
            alertMessage = "\(error.localizedDescription)"
        }
    }
    
    func fetchAllInsurance(for carModel: CarModel) {
        do {
            self.insurances = try insuranceUseCase.fetchAllInsurances(for: carModel)
        } catch {
            alertMessage = "\(error.localizedDescription)"
        }
    }
    
    func updateInsurance(for carModel: CarModel, with insuranceModel: InsuranceModel) {
        do {
            try insuranceUseCase.updateInsurance(for: carModel, with: insuranceModel)
        } catch {
            alertMessage = "\(error.localizedDescription)"
        }
    }
    
    func resetField() {
        self.type = ""
        self.nameCompany = ""
        self.startDate = Date()
        self.endDate = Date()
        self.price = 0
        self.notes = ""
        self.notificationDate = nil
        self.isActive = true
    }
    
    func loadInsuranceInfo(from insurance: InsuranceModel) {
        self.selectedInsurance = insurance
        self.type = insurance.type
        self.nameCompany = insurance.nameCompany
        self.startDate = insurance.startDate
        self.endDate = insurance.endDate
        self.price = insurance.price
        self.notes = insurance.notes ?? ""
        self.notificationDate = insurance.notificationDate
        self.isActive = insurance.isActive
    }
    
    func deleteInsurance(insuranceModel: InsuranceModel) {
        do {
            try insuranceUseCase.deleteInsurance(insuranceModel: insuranceModel)
            if let index = insurances.firstIndex(of: insuranceModel) {
                insurances.remove(at: index)
            }
            NotificationService.shared.removeNotification(id: insuranceModel.id.uuidString)
        } catch {
            alertMessage = "\(error.localizedDescription)"
        }
    }
}
