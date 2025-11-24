//
//  DetailRepairView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 24.03.2025.
//


import SwiftUI
import PhotosUI

struct DetailRepairView: View {
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    @State private var isRepairEditing: Bool = false
    
    @State private var editedPartName: String = ""
    @State private var editedRepairDate: Date = Date.now
    @State private var editedCost: Int? = nil
    @State private var editedMileage: Int? = nil
    @State private var editCategory: RepairCategory = .fuel
    @State private var editedNotes: String = ""
    @State private var editPartsRepair: [Part] = []
    @State private var editedPhotoRepair: [UIImage] = []
    @State private var editedLitres: Double = 0
    
    let repair: RepairModel
    
    private func loadRepairForEditing() {
        editedPartName = repair.partReplaced
        editedRepairDate = repair.repairDate
        editedCost = Int(repair.amount)
        editedMileage = Int(repair.repairMileage)
        editCategory = RepairCategory(rawValue: repair.repairCategory) ?? .service
        editedNotes = repair.notes ?? ""
        editedPhotoRepair = ImageMapper.convertToUIImage(images: repair.photoRepairs)
        editedLitres = repair.litresFuel ?? 0
        editPartsRepair = PartMappers.fromDictionary(repair.parts)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                HeaderView(
                    isRepairEditing: $isRepairEditing,
                    partName: $editedPartName,
                    repairDate: $editedRepairDate,
                    repair: repair)
                
                InfoCardView(
                    isRepairEditing: $isRepairEditing,
                    cost: $editedCost,
                    mileage: $editedMileage,
                    category: $editCategory,
                    notes: $editedNotes,
                    repair: repair)
                
                if isRepairEditing || !(repair.parts.isEmpty) {
                    PartsView(
                        isRepairEditing: $isRepairEditing,
                        partsList: $editPartsRepair,
                        repair: repair)
                }
                
                Divider()
                
                if isRepairEditing || !(repair.photoRepairs?.isEmpty ?? true) {
                    ImageView(
                        isRepairEditing: $isRepairEditing,
                        photoRepair: $editedPhotoRepair,
                        repair: repair)
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isRepairEditing ? "Save" : "Edit") {
                    if isRepairEditing {
                        // ВНИМАНИЕ: updateRepair больше нет в старом виде
                        // Пока просто сохраняем локально — потом будет через Store
                        // Это временная заглушка, чтобы не падало
                        print("Сохранено (заглушка): \(editedPartName), \(editedCost ?? 0) ₽")
                    }
                    isRepairEditing.toggle()
                }
                .foregroundStyle(.primary)
            }
        }
        .onChange(of: isRepairEditing) { newValue in
            if newValue {
                loadRepairForEditing()
            }
        }
    }
}
