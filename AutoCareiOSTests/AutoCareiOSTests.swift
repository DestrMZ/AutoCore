//
//  AutoCareiOSTests.swift
//  AutoCareiOSTests
//
//  Created by Ivan Maslennikov on 02.05.2025.
//

import XCTest
@testable import AutoCareiOS

// MARK: - Mock Repair Model for Testing

struct Repair {
    var repairCategory: String?
    var amount: Double
    var repairDate: Date?
}

final class RepairStatsCalculatorTests: XCTestCase {
    
    var testRepairs: [Repair] = []
    
    override func setUp() {
        super.setUp()
        
        // Подготавливаем мок-данные
        let calendar = Calendar.current
        let today = Date()
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: today)!
        let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: today)!
        
        testRepairs = [
            Repair(repairCategory: "Engine", amount: 100, repairDate: today),
            Repair(repairCategory: "Tires", amount: 200, repairDate: oneWeekAgo),
            Repair(repairCategory: "Engine", amount: 150, repairDate: oneMonthAgo),
            Repair(repairCategory: "Brakes", amount: 300, repairDate: nil), // должно отфильтроваться
        ]
    }
    
    func testCategorySummary() {
        let calc = RepairStatsCalculator(repairs: testRepairs)
        let summary = calc.getCategorySummary(for: .allTime)
        
        XCTAssertEqual(summary["Engine"], 250)
        XCTAssertEqual(summary["Tires"], 200)
        XCTAssertEqual(summary["Brakes"], nil) // потому что nil-даты отфильтрованы
    }
    
    func testTotalAmount() {
        let calc = RepairStatsCalculator(repairs: testRepairs)
        let total = calc.getTotalAmount(for: .allTime)
        
        XCTAssertEqual(total, 100 + 200 + 150)
    }
    
    func testWeeklyFilter() {
        let calc = RepairStatsCalculator(repairs: testRepairs)
        let weeklySummary = calc.getCategorySummary(for: .week)
        
        // Только сегодняшняя запись попадает (Engine 100)
        XCTAssertEqual(weeklySummary["Engine"], 100)
        XCTAssertEqual(weeklySummary["Tires"], nil)
    }
    
    func testMonthlyFilter() {
        let calc = RepairStatsCalculator(repairs: testRepairs)
        let monthlySummary = calc.getCategorySummary(for: .month)
        
        // Сегодня + одна неделя назад = Engine 100 + Tires 200
        XCTAssertEqual(monthlySummary["Engine"], 100)
        XCTAssertEqual(monthlySummary["Tires"], 200)
    }
    
    func testPieChartData() {
        let calc = RepairStatsCalculator(repairs: testRepairs)
        let pieData = calc.getPieChartData(for: .allTime)
        
        XCTAssertEqual(pieData.count, 2) // Engine, Tires (Brakes с nil-датой не считается)
        let engineEntry = pieData.first { $0.label == "Engine" }
        XCTAssertEqual(engineEntry?.value, 250)
    }
}
