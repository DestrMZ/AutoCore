//
//  InsuranceListSelection.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 13.06.2025.
//

import SwiftUI

struct InsuranceListSelection: View {
    
    @StateObject private var vm: InsuranceViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var showSheet: Bool = false
    @State var showDeleteConfirmation: Bool = false
    
    var selectedCar: CarModel
    
    init(insuranceStore: InsuranceStore, selectedCar: CarModel) {
        self._vm = StateObject(wrappedValue: InsuranceViewModel(insuranceStore: insuranceStore))
        self.selectedCar = selectedCar
    }
   
    var body: some View {
        NavigationStack {
            LazyVStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Insurance")
                        .font(.title3.bold())
                    Spacer()
                    Button(action: {
                        showSheet = true
                    }) {
                        Label("Add", systemImage: "plus")
                            .labelStyle(.iconOnly)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .sheet(isPresented: $showSheet) {
                        AddInsuranceSheet(vm: vm, car: selectedCar)
                    }
                }
                .padding(.horizontal, 10)
                
                if vm.insurances.isEmpty {
                    VStack(alignment: .center, spacing: 12) {
                        Image(systemName: "doc.plaintext")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.gray)
                            .padding(.top, 12)

                        Text("No insurance yet")
                            .font(.headline)
                            .foregroundStyle(.secondary)

                        Text("Add your first policy to get reminders and stay informed.")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    ForEach(vm.insurances, id: \.id) { insurance in
                        InsuranceCardView(
                            insuranceCompany: insurance.nameCompany,
                            insuranceType: insurance.type,
                            startDate: insurance.startDate,
                            endDate: insurance.endDate)
                        .contextMenu {
                            Button(action: {
                                vm.loadInsuranceInfo(from: insurance)
                                showSheet = true
                            }) {
                                Label("Edit", systemImage: "pencil")
                            }
                            
                            Button(action: {
                                showDeleteConfirmation = true
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .alert("Confirm deletion?", isPresented: $showDeleteConfirmation) {
                            Button("Yes", role: .destructive) {
                                vm.deleteInsurance(insurance)
                            }
                            Button("Cancel", role: .cancel) { dismiss() }
                        }
                    }
                }
            }
        }
        .onAppear {
            vm.fetchAllInsurance(for: selectedCar)
        }
        .onChange(of: selectedCar) { newValue in
            vm.fetchAllInsurance(for: newValue)
        }
    }
}


#Preview {
    let mockCar = CarModel(id: UUID(), nameModel: "Tesla Model 3", year: 2023, engineType: "Gasoline", transmissionType: "Manual", mileage: 12000, vinNumbers: "5YJ3E1EA7JF123456")
    
    let insuranceModel = InsuranceModel(id: UUID(), type: "КАСКО", nameCompany: "Сберстрахование", startDate: Date().addingTimeInterval(-86_400), endDate: Date().addingTimeInterval(86_400), price: 22_000, isActive: true)
    
    let mockStore = InsuranceStore(insuranceUseCase: InsuranceUseCase(insuranceRepository: MockInsuranceRepository()))
    
    let mockVM = InsuranceViewModel(insuranceStore: mockStore)
    
    mockVM.addInsurance(for: mockCar, insurance: insuranceModel)

    return InsuranceListSelection(insuranceStore: mockStore, selectedCar: mockCar)
        .environmentObject(mockVM)
}
