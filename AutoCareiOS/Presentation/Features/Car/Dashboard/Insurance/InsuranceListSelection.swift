//
//  InsuranceListSelection.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 13.06.2025.
//

import SwiftUI

struct InsuranceListSelection: View {
    
    @EnvironmentObject var insuranceViewModel: InsuranceViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var showSheet: Bool = false
    @State var showDeleteConfirmation: Bool = false
    
    var selectedCar: CarModel
   
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
                        AddInsuranceSheet(car: selectedCar)
                    }
                }
                .padding(.horizontal, 10)
                
                if insuranceViewModel.insurances.isEmpty {
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
                    ForEach(insuranceViewModel.insurances, id: \.self) { insurance in
                        InsuranceCardView(
                            insuranceCompany: insurance.nameCompany,
                            insuranceType: insurance.type,
                            startDate: insurance.startDate,
                            endDate: insurance.endDate)
                        .contextMenu {
                            Button(action: {
                                insuranceViewModel.loadInsuranceInfo(from: insurance)
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
                                if let index = insuranceViewModel.insurances.firstIndex(of: insurance) {
                                    insuranceViewModel.deleteInsurance(at: IndexSet(integer: index))
                                }
                            }
                            Button("Cancel", role: .cancel) { dismiss() }
                        }
                    }
                }
            }
        }
        .onAppear {
            insuranceViewModel.loadInsurances(car: selectedCar)
        }
        .onChange(of: selectedCar) { newValue in
        guard let selectedCar = newValue else { return }
            insuranceViewModel.loadInsurances(car: selectedCar)
        }
    }
}


#Preview {
    InsuranceListSelection(insuranceViewModel: InsuranceViewModel())
}
