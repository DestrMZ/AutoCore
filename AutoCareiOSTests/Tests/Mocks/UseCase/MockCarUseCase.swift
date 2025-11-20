//
//  MockCarUseCase.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 20.11.2025.
//


import XCTest
@testable import AutoCareiOS

final class CarUseCaseTests: XCTestCase {

    var carRepository: MockCarRepository!
    var userStore: MockUserStoreRepository!
    var useCase: CarUseCase!

    override func setUp() {
        super.setUp()
        carRepository = MockCarRepository()
        userStore = MockUserStoreRepository()
        useCase = CarUseCase(carRepository: carRepository, userStoreRepository: userStore)
    }

    override func tearDown() {
        carRepository = nil
        userStore = nil
        useCase = nil
        super.tearDown()
    }

    // MARK: - initializeCar

    func test_initializeCar_SelectsLastSavedCar() throws {
        let car1 = CarModel.mock(id: UUID(), mileage: 1000)
        let car2 = CarModel.mock(id: UUID(), mileage: 2000)
        carRepository.mockCars = [car1, car2]
        userStore.lastSelectedVin = car2.vinNumbers  // VIN генерируется автоматически

        let selected = try useCase.initializeCar(cars: [car1, car2])

        XCTAssertEqual(selected?.id, car2.id)
    }

    func test_initializeCar_ReturnsNilIfNoCars() throws {
        let result = try useCase.initializeCar(cars: [])
        XCTAssertNil(result)
    }

    // MARK: - createCar

    func test_createCar_Success() throws {
        let car = CarModel.mock()
        let created = try useCase.createCar(carModel: car)

        XCTAssertEqual(created.id, car.id)
        XCTAssertEqual(carRepository.mockCars.count, 1)
    }

    func test_createCar_ThrowsDuplicateVin_WhenSameVinExists() throws {
        let existing = CarModel.mock(id: UUID())  // у него свой VIN
        carRepository.mockCars = [existing]

        // Создаём машину с ТЕМ ЖЕ VIN — вручную копируем
        var duplicate = CarModel.mock(id: UUID())
        duplicate.vinNumbers = existing.vinNumbers

        XCTAssertThrowsError(try useCase.createCar(carModel: duplicate)) { error in
            XCTAssertEqual(error as? CarError, .duplicateVinNumber)
        }
    }

    // MARK: - updateMileage

    func test_updateMileage_UpdatesSuccessfully() throws {
        let car = CarModel.mock(mileage: 10_000)
        carRepository.mockCars = [car]

        try useCase.updateMileage(for: car, newMileage: 85_000)

        XCTAssertEqual(carRepository.mockCars.first?.mileage, 85_000)
    }

    func test_updateMileage_ThrowsIfNegative() throws {
        let car = CarModel.mock()
        carRepository.mockCars = [car]

        XCTAssertThrowsError(try useCase.updateMileage(for: car, newMileage: -100)) { error in
            XCTAssertEqual(error as? CarError, .mileageNegative)
        }
    }

    func test_updateMileage_ThrowsIfOverLimit() throws {
        let car = CarModel.mock()
        carRepository.mockCars = [car]

        XCTAssertThrowsError(try useCase.updateMileage(for: car, newMileage: 6_000_000)) { error in
            XCTAssertEqual(error as? CarError, .mileageExceedsLimit)
        }
    }

    // MARK: - validateCar — эти тесты требуют создать машину с пустыми полями вручную

    func test_validateCar_ThrowsIfNameEmpty() throws {
        var car = CarModel.mock()
        car.nameModel = "   "  // принудительно делаем пустое имя

        XCTAssertThrowsError(try useCase.validateCar(car: car)) { error in
            XCTAssertEqual(error as? CarError, .missingNameModel)
        }
    }

    func test_validateCar_ThrowsIfVinEmpty() throws {
        var car = CarModel.mock()
        car.vinNumbers = ""

        XCTAssertThrowsError(try useCase.validateCar(car: car)) { error in
            XCTAssertEqual(error as? CarError, .missingVinNumber)
        }
    }

    func test_validateCar_ThrowsIfYearZero() throws {
        var car = CarModel.mock()
        car.year = 0

        XCTAssertThrowsError(try useCase.validateCar(car: car)) { error in
            XCTAssertEqual(error as? CarError, .missingYear)
        }
    }

    // MARK: - selectCar

    func test_selectCar_SavesVinToUserStore() {
        let car = CarModel.mock()
        useCase.selectCar(car: car)

        XCTAssertEqual(userStore.lastSelectedVin, car.vinNumbers)
    }
}
