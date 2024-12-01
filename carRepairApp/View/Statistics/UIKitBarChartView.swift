//
//  UIKitBarChartView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 01.12.2024.
//

import Foundation
import DGCharts
import SwiftUI


struct UIKitBarChartView: UIViewRepresentable {
    
    var selectedCar: Car
    var entity: [BarChartDataEntry]
    
    func makeUIView(context: Context) -> BarChartView {
        return BarChartView()
    }
    
    func updateUIView(_ uiView: BarChartView, context: Context) {
        let dataSet = BarChartDataSet(entries: entity)
        
        dataSet.colors = ChartColorTemplates.material()
        dataSet.valueTextColor = .black
        
        uiView.xAxis.labelPosition = .bottom
        uiView.xAxis.drawGridLinesEnabled = false
        uiView.rightAxis.drawLabelsEnabled = false
        uiView.isUserInteractionEnabled = false
        
        uiView.legend.enabled = false

        uiView.data = BarChartData(dataSet: dataSet)
    }
}


struct UIKitBarChartView_Previews: PreviewProvider {
    static var previews: some View {
        let mokCar = Car(context: CoreDataManaged.shared.persistentContainer.viewContext)
        let entity = DateOfAmount.BarChartAllEntity(entity: DateOfAmount.allEntity)
        return UIKitBarChartView(selectedCar: mokCar, entity: entity)
            .environmentObject(CarViewModel())
            .environmentObject(RepairViewModel())
            .frame(width: 400, height: 300)
    }
}

// TEST
struct DateOfAmount {
    
    var amount: Double
    var date: Double
    
    static func BarChartAllEntity(entity: [DateOfAmount]) -> [BarChartDataEntry] {
        return entity.map { BarChartDataEntry(x: $0.date, y: $0.amount) }
        }
    
    static var allEntity: [DateOfAmount] {
        return [
            DateOfAmount(amount: 100, date: 1),
            DateOfAmount(amount: 200, date: 2),
            DateOfAmount(amount: 300, date: 3),
            DateOfAmount(amount: 150, date: 4),
            DateOfAmount(amount: 250, date: 5),
            DateOfAmount(amount: 350, date: 6),
            DateOfAmount(amount: 120, date: 7),
            DateOfAmount(amount: 220, date: 8),
            DateOfAmount(amount: 320, date: 9),
            DateOfAmount(amount: 180, date: 10),
            DateOfAmount(amount: 280, date: 11),
            DateOfAmount(amount: 800, date: 12)
        ]
    }
}
