//
//  Template.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 20.04.2025.
//

import Foundation

// Обновление данных пробега авто
//        if let repairMileage = repairMileage, let carMileage = car?.mileage {
//            if repairMileage > carMileage {
//                car?.mileage = repairMileage
//            }
//        }


// MARK: Сохранение изображения ремонта в Core Data

//    func saveImageCarToCoreData(image: UIImage, for car: Car?) {
//        guard let car = car else { return }
//        guard let imageDataCar = image.jpegData(compressionQuality: 0.1) else { return }
//
//        car.photoCar = imageDataCar
//
//        do {
//            try CoreDataStack.shared.context.save()
//            print("INFO: Изображение автомобиля успешно сохранено.")
//        } catch {
//            print("WARNING: Ошибка при сохранении изображения автомобиля: \(error.localizedDescription)")
//        }
//    }
//
//
//    func saveImagesRepairToCoreData(images: [UIImage]) {
//        var tempArray: [Data] = []
//
//        guard !images.isEmpty else {
//                print("WARNING: Передан пустой массив изображений.")
//                return
//            }
//
//        for image in images {
//            let imageData = image.jpegData(compressionQuality: 0.1)
//            tempArray.append(imageData!)
//        }
//
//        let repair = Repair(context: CoreDataStack.shared.context)
//        repair.photoRepair = tempArray
//
//        do {
//            try CoreDataStack.shared.context.save()
//        } catch {
//            print("WARNING: Ошибка сохранения изображения поломки: \(error.localizedDescription)")
//        }
//    }
//
//    func fetchImageCarFromCoreData(car: Car) -> UIImage? {
//        if let photoData = car.photoCar {
//            return UIImage(data: photoData)
//        }
//        return nil
//    }
//
//    func fetchImagesRepairCoreData(repair: Repair) -> [UIImage] {
//        var tempArray: [UIImage] = []
//        if let imagesData = repair.photoRepair {
//
//            for image in imagesData {
//                if let imageData = UIImage(data: image) {
//                    tempArray.append(imageData)
//                }
//            }
//        }
//        return tempArray
//    }


import SwiftUI

struct CarFormWithErrorTips: View {
    @State private var name: String = ""
    @State private var year: String = ""
    @State private var mileage: String = ""

    @State private var nameError: String? = nil
    @State private var yearError: String? = nil
    @State private var mileageError: String? = nil

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Car Info")) {
                    VStack(alignment: .leading) {
                        TextField("Model Name", text: $name)
                            .textFieldStyle(.roundedBorder)
                        if let error = nameError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

                    VStack(alignment: .leading) {
                        TextField("Year", text: $year)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                        if let error = yearError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

                    VStack(alignment: .leading) {
                        TextField("Mileage", text: $mileage)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                        if let error = mileageError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Add Car")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        validateFields()
                    }
                }
            }
        }
    }

    private func validateFields() {
        nameError = name.isEmpty ? "Please enter the car model." : nil

        if year.isEmpty {
            yearError = "Please enter the year."
        } else if Int(year) == nil {
            yearError = "Year must be a number."
        } else {
            yearError = nil
        }

        if mileage.isEmpty {
            mileageError = "Please enter the mileage."
        } else if Int(mileage) == nil {
            mileageError = "Mileage must be a number."
        } else {
            mileageError = nil
        }
    }
}

#Preview {
    CarFormWithErrorTips()
}
