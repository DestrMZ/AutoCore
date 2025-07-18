//
//  DetailRepairView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 24.03.2025.
//

import SwiftUI
import PhotosUI

struct DetailRepairView: View {
    
    @EnvironmentObject var repairViewModel: RepairViewModel
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
    
    var repair: RepairModel
    var car: CarModel
    
    private func loadRepairForEditing() {
        editedPartName = repair.partReplaced
        editedRepairDate = repair.repairDate
        editedCost = Int(repair.amount)
        editedMileage = Int(repair.repairMileage)
        editCategory = RepairCategory(rawValue: repair.repairCategory) ?? .service
        editedNotes = repair.notes ?? ""
        editedPhotoRepair = ImageMapper.convertToUIImage(images: repair.photoRepairs)
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
                Button(isRepairEditing ? "Save" : "Edit", action: {
                    if isRepairEditing {
                        repairViewModel.updateRepair(for: car, repairModel: RepairModel(
                            id: repair.id,
                            amount: Int32(editedCost ?? 0),
                            litresFuel: editedLitres,
                            notes: editedNotes,
                            partReplaced: editedPartName,
                            parts: PartMappers.toDictionary(editPartsRepair),
                            photoRepairs: ImageMapper.convertToData(images: editedPhotoRepair),
                            repairCategory: editCategory.rawValue,
                            repairDate: editedRepairDate,
                            repairMileage: Int32(editedMileage ?? 0)))
                    }
                    isRepairEditing.toggle()
                })
                .foregroundStyle(.primary)
            }
        }
        .onChange(of: isRepairEditing) { newValue in
            if newValue {
                loadRepairForEditing()
            }
        } // При переходе в режим редактирования, загружаем информацию в edit-свойства
    }
}


#Preview {
    let mockRepair = RepairModel(
        id: UUID(),
        amount: 15000,
        litresFuel: 0,
        notes: "Замена масла и фильтров",
        partReplaced: "Масляный фильтр",
        parts: ["F123": "Фильтр"],
        photoRepairs: nil,
        repairCategory: RepairCategory.service.rawValue,
        repairDate: Date(),
        repairMileage: 120000
    )

    let mockCar = CarModel(
        id: UUID(),
        nameModel: "Toyota Corolla",
        year: 2015,
        color: "Белый",
        engineType: "gasoline",
        transmissionType: "automatic",
        mileage: 120000,
        photoCar: Data(),
        vinNumbers: "JTDBL40E799999999",
        repairs: [mockRepair],
        insurance: nil,
        stateNumber: "А123ВС"
    )

    let mockRepairViewModel = RepairViewModel(repairUseCase: RepairUseCase(repairRepository: MockRepairRepository()))
    let mockSettingsViewModel = SettingsViewModel()
    
    DetailRepairView(repair: mockRepair, car: mockCar)
}
