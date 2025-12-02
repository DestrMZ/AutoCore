//
//  DetailRepairView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 24.03.2025.
//


import SwiftUI
import PhotosUI

struct DetailRepairView: View {
    
    @StateObject var detailViewModel: RepairDetailViewModel
    @Environment(\.dismiss) var dismiss
    
    init(repair: RepairModel, carStore: CarStore, repairStore: RepairStore) {
        _detailViewModel = StateObject(wrappedValue: RepairDetailViewModel(repair: repair, carStore: carStore, repairStore: repairStore))
    }
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                HeaderView(
                    isRepairEditing: $detailViewModel.isEditing,
                    partName: $detailViewModel.nameRepair,
                    repairDate: $detailViewModel.date,
                    repair: detailViewModel.currentRepair)
                
                InfoCardView(
                    isRepairEditing: $detailViewModel.isEditing,
                    cost: $detailViewModel.amount,
                    mileage: $detailViewModel.mileage,
                    category: $detailViewModel.category,
                    notes: $detailViewModel.notes,
                    repair: detailViewModel.currentRepair)
                
                if detailViewModel.isEditing || !(detailViewModel.currentRepair.parts.isEmpty) {
                    PartsView(
                        isRepairEditing: $detailViewModel.isEditing,
                        partsList: $detailViewModel.parts,
                        repair: detailViewModel.currentRepair)
                }
                
                Divider()
                
                if detailViewModel.isEditing || !(detailViewModel.currentRepair.photoRepairs?.isEmpty ?? true) {
                    ImageView(
                        isRepairEditing: $detailViewModel.isEditing,
                        photoRepair: $detailViewModel.photoData,
                        repair: detailViewModel.currentRepair)
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(detailViewModel.isEditing ? "Save" : "Edit") {
                    if detailViewModel.isEditing {
                        if detailViewModel.saveChanges() {
                            detailViewModel.isEditing = false
                        }
                    } else {
                        detailViewModel.isEditing = true
                    }
                }
                .foregroundStyle(.primary)
            }
        }
        .onChange(of: detailViewModel.isEditing) { newValue in
            if newValue {
                // Загружаем данные при входе в режим редактирования
                detailViewModel.loadRepairData()
            }
            // При выходе из режима редактирования currentRepair уже обновлен после saveChanges
        }
        .alert("Error", isPresented: $detailViewModel.isShowAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(detailViewModel.alertMessage ?? "")
        }
    }
}
