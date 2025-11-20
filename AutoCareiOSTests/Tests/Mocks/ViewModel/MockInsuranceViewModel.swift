//
//  MockInsuranceViewModel.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 20.11.2025.
//

import Foundation
import XCTest
@testable import AutoCareiOS


@MainActor
final class InsuranceViewModelTests: XCTestCase {
    func testFetchAllInsurancePropagatesFromStore() {
        let car = CarModel.mock()
        let insurance = InsuranceModel.mock()
        let mock = InsuranceUseCaseMock(insurances: [insurance])
        let store = InsuranceStore(insuranceUseCase: mock)
        let viewModel = InsuranceViewModel(insuranceStore: store)

        viewModel.fetchAllInsurance(for: car)

        XCTAssertEqual(viewModel.insurances.count, 1)
    }

    func testErrorHandlingShowsAlert() {
        let car = CarModel.mock()
        let mock = InsuranceUseCaseMock(insurances: [])
        mock.error = NSError(domain: "Insurance", code: 1)
        let store = InsuranceStore(insuranceUseCase: mock)
        let viewModel = InsuranceViewModel(insuranceStore: store)

        viewModel.addInsurance(for: car, insurance: .mock())

        XCTAssertTrue(viewModel.isShowAlert)
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
    }
}
