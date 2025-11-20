//
//  MockInsuranceStore.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 20.11.2025.
//

import Foundation
import XCTest
@testable import AutoCareiOS


@MainActor
final class InsuranceStoreTests: XCTestCase {
    func testAddInsuranceAppendsItem() throws {
        let car = CarModel.mock()
        let insurance = InsuranceModel.mock()
        let mock = InsuranceUseCaseMock(insurances: [])
        let store = InsuranceStore(insuranceUseCase: mock)

        try store.addInsurance(for: car, insuranceModel: insurance)

        XCTAssertEqual(store.insurances.count, 1)
        XCTAssertEqual(store.insurances.first?.id, insurance.id)
    }

    func testUpdateInsuranceReplacesExisting() throws {
        let car = CarModel.mock()
        let insurance = InsuranceModel.mock()
        var updated = insurance
        updated.nameCompany = "Updated"
        let mock = InsuranceUseCaseMock(insurances: [insurance])
        let store = InsuranceStore(insuranceUseCase: mock)

        try store.updateInsurance(for: car, insuranceModel: updated)

        XCTAssertEqual(store.insurances.first?.nameCompany, "Updated")
    }

    func testDeleteInsuranceRemovesItem() throws {
        let car = CarModel.mock()
        let insurance = InsuranceModel.mock()
        let mock = InsuranceUseCaseMock(insurances: [insurance])
        let store = InsuranceStore(insuranceUseCase: mock)

        try store.deleteInsurance(insurance)

        XCTAssertTrue(store.insurances.isEmpty)
        XCTAssertNil(store.selectedInsurance)
    }
}
