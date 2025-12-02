//
//  RepairDetailViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 24.11.2025.
//
//


import Foundation
import SwiftUI
import PhotosUI

@MainActor
final class RepairDetailViewModel: ObservableObject {

    private let repairStore: RepairStore
    private let carStore: CarStore
    
    @Published var currentRepair: RepairModel

    @Published var nameRepair = ""
    @Published var amount = ""
    @Published var mileage = ""
    @Published var date = Date()
    @Published var notes = ""
    @Published var litres = ""
    @Published var category: RepairCategory = .service
    @Published var parts = [Part(article: "", name: "")]
    @Published var photoData: [Data] = []
    @Published var selectedPhotos: [PhotosPickerItem] = []

    @Published var isLoading = false
    @Published var alertMessage: String?
    @Published var isShowAlert = false

    @Published var isEditing: Bool = false

    init(
        repair: RepairModel,
        carStore: CarStore,
        repairStore: RepairStore
    ) {
        self.currentRepair = repair
        self.carStore = carStore
        self.repairStore = repairStore

        loadRepairData()
    }

    // MARK: - Загрузка данных при открытии редактирования
    func loadRepairData() {
        nameRepair = currentRepair.partReplaced
        amount = String(currentRepair.amount)
        mileage = String(currentRepair.repairMileage)
        date = currentRepair.repairDate
        notes = currentRepair.notes ?? ""
        litres = currentRepair.litresFuel.map { String($0) } ?? ""
        category = RepairCategory(rawValue: currentRepair.repairCategory) ?? .service
        parts = PartMappers.fromDictionary(currentRepair.parts)
        photoData = currentRepair.photoRepairs ?? []
    }

    func addPart() {
        parts.append(Part(article: "", name: ""))
    }

    func removePart(at offsets: IndexSet) {
        parts.remove(atOffsets: offsets)
    }

    func loadPhotos(from items: [PhotosPickerItem]) async {
        isLoading = true
        var loaded: [Data] = []

        await withTaskGroup(of: Data?.self) { group in
            for item in items {
                group.addTask {
                    try? await item.loadTransferable(type: Data.self)
                }
            }
            for await data in group {
                if let data { loaded.append(data) }
            }
        }

        photoData.append(contentsOf: loaded)
        isLoading = false
    }

    func saveChanges() -> Bool {
        guard let car = carStore.selectedCar else {
            showError("Автомобиль не выбран")
            return false
        }

        guard !nameRepair.trimmingCharacters(in: .whitespaces).isEmpty,
              Int(amount) != nil else {
            showError("Заполните название и сумму")
            return false
        }

        let updatedRepair = RepairModel(
            id: currentRepair.id,
            amount: Int32(amount) ?? 0,
            litresFuel: category == .fuel ? Double(litres) ?? nil : nil,
            notes: notes.isEmpty ? nil : notes,
            partReplaced: nameRepair,
            parts: PartMappers.toDictionary(parts.filter { !$0.name.isEmpty }),
            photoRepairs: photoData.isEmpty ? nil : photoData,
            repairCategory: category.rawValue,
            repairDate: date,
            repairMileage: Int32(mileage) ?? car.mileage
        )

        do {
            try repairStore.updateRepair(for: car, repairModel: updatedRepair)
            // Обновляем currentRepair после успешного сохранения
            currentRepair = updatedRepair
            return true
        } catch {
            showError(error.localizedDescription)
            return false
        }
    }

    private func showError(_ message: String) {
        alertMessage = message
        isShowAlert = true
    }
}
