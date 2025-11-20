//
//  MockCarStore.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 20.11.2025.
//

import Foundation
import XCTest
@testable import AutoCareiOS


@MainActor
final class CarStoreTests: XCTestCase {
    func testInitializeStoresCarsAndSelectsFirst() async {
        let mock = CarUseCaseMock(cars: [.mock()])
        let store = CarStore(carUseCase: mock)

        await store.initialize()

        XCTAssertEqual(store.cars.count, 1)
        XCTAssertEqual(store.selectedCar?.id, mock.cars.first?.id)
    }

    func testSelectCarUpdatesSelection() async {
        let car1 = CarModel.mock()
        let car2 = CarModel.mock()
        let mock = CarUseCaseMock(cars: [car1, car2])
        let store = CarStore(carUseCase: mock)

        await store.initialize()
        store.selectCar(car2)

        XCTAssertEqual(store.selectedCar?.id, car2.id)
        XCTAssertEqual(mock.selectedCar?.id, car2.id)
    }

    func testUpdateMileagePersistsInCollection() async throws {
        let car = CarModel.mock(mileage: 100)
        let mock = CarUseCaseMock(cars: [car])
        let store = CarStore(carUseCase: mock)

        await store.initialize()
        try store.updateMileage(for: car, newMileage: 200)

        XCTAssertEqual(store.cars.first?.mileage, 200)
    }
}
