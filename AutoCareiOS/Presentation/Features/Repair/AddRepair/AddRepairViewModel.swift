//
//  AddRepairViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 24.11.2025.
//

import Foundation
import _PhotosUI_SwiftUI


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
    @Published var selectedPhotos: [PhotosPickerItem] = []
    @Published var currentImages: [UIImage] = []

    @Published var isLoading = false
    @Published var alertMessage: String = ""
    @Published var isShowAlert: Bool = false

    init(carStore: CarStore, repairStore: RepairStore) {
        self.carStore = carStore
        self.repairStore = repairStore
    }

    func addPart() {
        parts.append(Part(article: "", name: ""))
    }

    func removePart(at offsets: IndexSet) {
        parts.remove(atOffsets: offsets)
    }

    var isFormValid: Bool {
        !nameRepair.trimmingCharacters(in: .whitespaces).isEmpty &&
        Int(amount) != nil &&
        (mileage.isEmpty || Int(mileage) != nil)
    }

    func save() async {
        guard let car = carStore.selectedCar else {
            return
        }

        guard isFormValid else {
            return
        }

        isLoading = true
        alertMessage = nil

        var photoData: [Data] = []
        for item in selectedPhotos {
            if let data = try? await item.loadTransferable(type: Data.self) {
                photoData.append(data)
            }
        }

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
            resetForm()
        } catch {
            handleError(error)
        }

        isLoading = false
    }

    func loadSelectedPhotos() async {
        var images: [UIImage] = []

        for item in selectedPhotos {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                images.append(image)
            }
        }

        await MainActor.run {
            self.currentImages.append(contentsOf: images)
            self.selectedPhotos = []
        }
    }
    
    func removePhoto(_ image: UIImage) {
        currentImages.removeAll { $0 == image }
    }

    private func imagesData() -> [Data]? {
        guard !currentImages.isEmpty else { return nil }
        return currentImages.compactMap { $0.jpegData(compressionQuality: 0.8) }
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
        selectedPhotos = []
        currentImages = []
    }
    
    private func handleError(_ error: Error) {
        alertMessage = error.localizedDescription
        isShowAlert = true
    }
}
