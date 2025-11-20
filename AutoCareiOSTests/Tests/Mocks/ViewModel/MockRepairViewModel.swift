//
//  MockRepairViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 20.11.2025.
//

import Foundation
import XCTest
@testable import AutoCareiOS


@MainActor
final class MockRepairViewModelTests: XCTestCase {
    func testAddRepairAppends() {
        let car = CarModel.mock()
        let mock = RepairUseCaseMock(repairs: [])
        let viewModel = RepairViewModel(repairUseCase: mock)

        viewModel.addRepair(for: car, repairModel: .mock())

        XCTAssertEqual(viewModel.repairs.count, 1)
    }

    func testGetLastRefuelHandlesErrors() {
        let car = CarModel.mock()
        let mock = RepairUseCaseMock(repairs: [])
        let viewModel = RepairViewModel(repairUseCase: mock)

        mock.error = NSError(domain: "Refuel", code: 1)
        let result = viewModel.getLastRefuel(repairs: [.mock()])

        XCTAssertEqual(result.litres, "None")
        XCTAssertTrue(viewModel.alertMessage.contains("Refuel"))
    }
}
