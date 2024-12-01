////
////  PieChartView.swift
////  carRepairApp
////
////  Created by Ivan Maslennikov on 22.11.2024.
////

import SwiftUI
import DGCharts


struct UIKitPieChartView: UIViewRepresentable {

    var selectedCar: Car
    var entity: [PieChartDataEntry]


    func makeUIView(context: Context) -> PieChartView {
        return PieChartView()
    }

    func updateUIView(_ uiView: PieChartView, context: Context) {
        let dataSet = PieChartDataSet(entries: entity)
        dataSet.colors = [.blackRed, .dim, .citron, .teaGreen, .davyGray, .dimGray]
        
        dataSet.sliceSpace = 3
        dataSet.label = nil
        dataSet.drawValuesEnabled = true
        dataSet.valueFont = .boldSystemFont(ofSize: 12)
    
        
        uiView.drawHoleEnabled = true
        uiView.highlightPerTapEnabled = false
        uiView.rotationEnabled = false
        uiView.holeColor = UIColor.systemBackground
        uiView.drawEntryLabelsEnabled = false

        uiView.legend.enabled = true
        uiView.legend.horizontalAlignment = .center

        uiView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
        uiView.data = PieChartData(dataSet: dataSet)
    }
}


struct UIKitPieChartView_Preview: PreviewProvider {
    static var previews: some View {
        let mockCar = Car(context: CoreDataManaged.shared.persistentContainer.viewContext)
        let entityes = CategoriesAndAmount.PieChartAllEntity(entity: CategoriesAndAmount.allEntity)

        return UIKitPieChartView(selectedCar: mockCar, entity: entityes)
            .environmentObject(CarViewModel())
            .environmentObject(RepairViewModel())
    }
}


struct CategoriesAndAmount {
    
    var category: String
    var amount: Double
    
    static func PieChartAllEntity(entity: [CategoriesAndAmount]) -> [PieChartDataEntry] {
        return entity.map { PieChartDataEntry(value: $0.amount, label: $0.category) }
       }
    
    static var allEntity: [CategoriesAndAmount] {
        [
            CategoriesAndAmount(category: "Service", amount: 2500),
            CategoriesAndAmount(category: "Washing", amount: 350),
            CategoriesAndAmount(category: "Parking", amount: 400)
        ]
    }
}
