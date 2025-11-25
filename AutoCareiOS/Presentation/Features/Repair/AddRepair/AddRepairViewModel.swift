//
//  AddRepairViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 24.11.2025.
//

import Foundation
import PhotosUI
import SwiftUI


@MainActor
final class AddRepairViewModel: ObservableObject {

    private let repairStore: RepairStore
    private let carStore: CarStore

    @Published var nameRepair = ""
    @Published var amount = ""
    @Published var mileage = ""
    @Published var date = Date()
    @Published var notes = ""
    @Published var litres = ""
    @Published var category: RepairCategory = .service
    @Published var parts = [Part(article: "", name: "")]
    @Published var photoData: [Data] = []

    @Published var alertMessage: String = ""
    @Published var isShowAlert: Bool = false
    @Published var showSuccessMessage: Bool = false

    init(carStore: CarStore, repairStore: RepairStore) {
        self.carStore = carStore
        self.repairStore = repairStore
    }
    
    func createRepair() {
        guard let car = carStore.selectedCar else { return }
        
        let newRepair = RepairModel(
            id: UUID(),
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
            try repairStore.addRepair(for: car, repairModel: newRepair)
        } catch {
            handleError(error)
        }
    }
    
    func resetForm() {
        nameRepair = ""
        amount = ""
        mileage = ""
        date = Date()
        notes = ""
        litres = ""
        category = .service
        parts = [Part(article: "", name: "")]
    }
    
    func addPart() {
        parts.append(Part(article: "", name: ""))
    }

    func removePart(at offsets: IndexSet) {
        parts.remove(atOffsets: offsets)
    }
    
    func loadPhotos(from items: [PhotosPickerItem]) async {
        var loadedData: [Data] = []

        await withTaskGroup(of: Data?.self) { group in
            for item in items {
                group.addTask {
                    try? await item.loadTransferable(type: Data.self)
                }
            }

            for await result in group {
                if let data = result {
                    loadedData.append(data)
                }
            }
        }

        if !photoData.isEmpty {
            photoData.append(contentsOf: loadedData)
            showSuccessMessage = true
        }
    }
    
    private func handleError(_ error: Error) {
        alertMessage = error.localizedDescription
        isShowAlert = true
    }
}
