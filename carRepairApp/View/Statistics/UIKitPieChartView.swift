////
////  PieChartView.swift
////  carRepairApp
////
////  Created by Ivan Maslennikov on 22.11.2024.
////

import SwiftUI
import Charts
import DGCharts


struct UIKitPieChartView: UIViewRepresentable {

    var selectedCar: Car
    var entity: [PieChartDataEntry]


    func makeUIView(context: Context) -> PieChartView {
        return PieChartView()
    }

    func updateUIView(_ uiView: PieChartView, context: Context) {
        let dataSet = PieChartDataSet(entries: entity)
        uiView.data = PieChartData(dataSet: dataSet)
    }
}
