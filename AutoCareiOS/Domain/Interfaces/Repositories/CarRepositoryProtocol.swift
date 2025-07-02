//
//  CarRepositoryProtocol.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 29.06.2025.
//

import Foundation


protocol CarRepositoryProtocol {
    func createCar(_ carModel: CarModel) throws -> CarModel

    func fetchAllCars() throws -> [CarModel]
    
    func getCar(carID: UUID) throws -> CarModel

    func updateCar(_ car: CarModel) throws

    func updateMileage(for car: CarModel, newMileage: Int32) throws
    
    func changeImage(for car: CarModel, image: Data) throws
    
    func deleteCar(_ car: CarModel) throws
}
