//
//  MockRepairStore.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 20.11.2025.
//

import Foundation
import XCTest
@testable import AutoCareiOS


@MainActor
final class RepairStoreTests: XCTestCase {
    func testLoadRepairsUsesUseCase() throws {
        let car = CarModel.mock()
        let repairs = [RepairModel.mock()]
        let mock = RepairUseCaseMock(repairs: repairs)
        let store = RepairStore(repairUseCase: mock)

        try store.loadRepairs(for: car)

        XCTAssertEqual(store.repairs.count, repairs.count)
    }

    func testUpdateRepairMutatesCollection() throws {
        let car = CarModel.mock()
        let repair = RepairModel.mock()
        var updated = repair
        updated.notes = "Changed"
        let mock = RepairUseCaseMock(repairs: [repair])
        let store = RepairStore(repairUseCase: mock)

        try store.updateRepair(for: car, repairModel: updated)

        XCTAssertEqual(store.repairs.first?.notes, "Changed")
    }
}
