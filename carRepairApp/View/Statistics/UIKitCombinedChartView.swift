//
//  UIKitBarChartView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 01.12.2024.
//

import Foundation
import DGCharts
import SwiftUI


struct UIKitCombinedChartView: UIViewRepresentable {
    
    var selectedCar: Car
    var entityForBar: [BarChartDataEntry]
    var entityForLine: [ChartDataEntry]
    
    func makeUIView(context: Context) -> CombinedChartView {
        return CombinedChartView()
    }
    
    var months = [
        "", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ]
    
    func updateUIView(_ uiView: CombinedChartView, context: Context) {

        let barDataSet = BarChartDataSet(entries: entityForBar, label: NSLocalizedString("Expenses for the month", comment: ""))
        let lineDataSet = LineChartDataSet(entries: entityForLine, label: NSLocalizedString("Trand", comment: ""))
        let combinedData = CombinedChartData()
        
        combinedData.barData = BarChartData(dataSet: barDataSet)
        combinedData.lineData = LineChartData(dataSet: lineDataSet)
        
        // Настройки Bar
        barDataSet.colors = [.blackRed] /*ChartColorTemplates.material()*/
        barDataSet.valueTextColor = UIColor.label
        barDataSet.valueFont = .systemFont(ofSize: 10)
        
        // Настройки линий
        lineDataSet.mode = .horizontalBezier
        lineDataSet.drawValuesEnabled = false
        lineDataSet.colors = [.yellow]
        lineDataSet.circleRadius = 3

        
        // Настройки UI
        uiView.isUserInteractionEnabled = false
        uiView.xAxis.granularity = 1
        uiView.xAxis.valueFormatter = IndexAxisValueFormatter(values: months)
        uiView.xAxis.labelCount = months.count
        uiView.xAxis.labelPosition = .bottom
        uiView.xAxis.drawGridLinesEnabled = false
        uiView.rightAxis.drawLabelsEnabled = false
        if let firstEntry = entityForLine.first, let lastEntry = entityForLine.last {
            uiView.xAxis.axisMinimum = firstEntry.x - 0.5
            uiView.xAxis.axisMaximum = lastEntry.x + 0.5
        }
        
        uiView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
        uiView.legend.enabled = true
        
        
        uiView.data = combinedData
    }
}


struct UIKitBarChartView_Previews: PreviewProvider {
    static var previews: some View {
        let mokCar = Car(context: CoreDataManaged.shared.persistentContainer.viewContext)
        let entityBar = DateOfAmount.BarChartAllEntity(entity: DateOfAmount.allEntityBar)
        let entityLine = DateOfAmount.BarChartAllEntity(entity: DateOfAmount.allEntityLine)
        return UIKitCombinedChartView(selectedCar: mokCar, entityForBar: entityBar, entityForLine: entityLine)
            .environmentObject(CarViewModel())
            .environmentObject(RepairViewModel())
            .frame(width: 400, height: 400)
    }
}

// TEST
struct DateOfAmount {
    
    var amount: Double
    var date: Double
    
    static func BarChartAllEntity(entity: [DateOfAmount]) -> [BarChartDataEntry] {
        return entity.map { BarChartDataEntry(x: $0.date, y: $0.amount) }
        }
    
    static var allEntityBar: [DateOfAmount] {
        return [
            DateOfAmount(amount: 100, date: 0),
            DateOfAmount(amount: 200, date: 1),
            DateOfAmount(amount: 300, date: 2),
            DateOfAmount(amount: 150, date: 3),
            DateOfAmount(amount: 250, date: 4),
            DateOfAmount(amount: 350, date: 5),
            DateOfAmount(amount: 120, date: 6),
            DateOfAmount(amount: 220, date: 7),
            DateOfAmount(amount: 320, date: 8),
            DateOfAmount(amount: 180, date: 9),
            DateOfAmount(amount: 280, date: 10),
            DateOfAmount(amount: 800, date: 11)
        ]
    }
    
    static var allEntityLine: [DateOfAmount] {
        return [
            DateOfAmount(amount: 100/2, date: 0),
            DateOfAmount(amount: 200/2, date: 1),
            DateOfAmount(amount: 300/2, date: 2),
            DateOfAmount(amount: 150/2, date: 3),
            DateOfAmount(amount: 250/2, date: 4),
            DateOfAmount(amount: 350/2, date: 5),
            DateOfAmount(amount: 120/2, date: 6),
            DateOfAmount(amount: 220/2, date: 7),
            DateOfAmount(amount: 320/2, date: 8),
            DateOfAmount(amount: 180/2, date: 9),
            DateOfAmount(amount: 280/2, date: 10),
            DateOfAmount(amount: 800/2, date: 11)
        ]
    }
}
