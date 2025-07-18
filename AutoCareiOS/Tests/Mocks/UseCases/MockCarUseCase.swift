////
////  MockCarUseCase.swift.swift
////  AutoCareiOS
////
////  Created by Ivan Maslennikov on 17.07.2025.
////
//
//import Foundation
//import Combine
//
//
//final class MockCarUseCase: CarUseCaseProtocol {
//    
//    private let mockCarRepository: CarRepositoryProtocol
//    private let userStoreRepository: UserStoreRepositoryProtocol
//    
//    let selectedCarPublisher: PassthroughSubject<CarModel, Never> = .init()
//    
//    init(mockCarRepository: CarRepositoryProtocol, userStoreRepository: UserStoreRepositoryProtocol) {
//        self.mockCarRepository = mockCarRepository
//        self.userStoreRepository = userStoreRepository
//    }
//    
//    func createCar(carModel: CarModel) throws -> CarModel {
//        <#code#>
//    }
//    
//    func selectCar(car: CarModel) {
//        <#code#>
//    }
//    
//    func initializeCar(cars: [CarModel]) throws -> CarModel? {
//        <#code#>
//    }
//    
//    func fetchAllCars() throws -> [CarModel] {
//        <#code#>
//    }
//    
//    func updateCar(carModel: CarModel) throws {
//        <#code#>
//    }
//    
//    func updateMileage(for car: CarModel?, newMileage: Int32?) throws {
//        <#code#>
//    }
//    
//    func changeImage(for carModel: CarModel, image: Data) throws {
//        <#code#>
//    }
//    
//    func deleteCar(carModel: CarModel) throws {
//        <#code#>
//    }
//    
//    func validateCar(car: CarModel) throws {
//        <#code#>
//    }
//    
//    
//}
