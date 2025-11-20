//
//  MockCarViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 20.11.2025.
//

import Foundation
import XCTest
@testable import AutoCareiOS


@MainActor
final class CarViewModelTests: XCTestCase {
    func testInitializeCarSelectsFirst() {
        let mock = CarUseCaseMock(cars: [.mock()])
        let viewModel = CarViewModel(carUseCase: mock)

        XCTAssertEqual(viewModel.selectedCar?.id, mock.cars.first?.id)
        XCTAssertFalse(viewModel.isShowAlert)
    }

    func testFetchCarsHandlesErrors() {
        let mock = CarUseCaseMock(cars: [])
        mock.fetchError = NSError(domain: "Fetch", code: 1)
        let viewModel = CarViewModel(carUseCase: mock)

        viewModel.fetchCars()

        XCTAssertTrue(viewModel.isShowAlert)
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
    }
}

@MainActor
final class CarProfileViewModelTests: XCTestCase {
    func testSyncsWithCarStoreChanges() async {
        let car1 = CarModel.mock()
        let car2 = CarModel.mock()
        let mock = CarUseCaseMock(cars: [car1, car2])
        let store = CarStore(carUseCase: mock)
        await store.initialize()

        let viewModel = CarProfileViewModel(carStore: store)
        store.selectCar(car2)

        XCTAssertEqual(viewModel.selectedCar?.id, car2.id)
        XCTAssertEqual(viewModel.cars.count, 2)
    }
}
