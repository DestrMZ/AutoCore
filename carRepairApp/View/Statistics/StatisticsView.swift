//
//  StatisticsView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 12.10.2024.
//

import SwiftUI
import DGCharts

struct StatisticsView: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    @EnvironmentObject var repairViewModel: RepairViewModel
    
    var selectedCar: Car { carViewModel.selectedCar! }

    var entity: [PieChartDataEntry] {
        if let selectedCar = carViewModel.selectedCar {
            return repairViewModel.getValueCategoriesAndAmount(for: selectedCar)
        } else { return [] }
    }
    
    var body: some View {
        VStack {
            
            TabView {
                
                VStack {
                    Text("Расходы по категориям").font(.headline).foregroundStyle(.secondary)
                    UIKitPieChartView(selectedCar: selectedCar, entity: entity)
                        .frame(width: 300, height: 300)
                        .padding()
                }.tag(0)
                
                VStack {
                    Text("Расходы за год").font(.headline).foregroundStyle(.secondary)
                    
                }.tag(1)
                
            }
            .tabViewStyle(PageTabViewStyle())
            
            
            List {
//                HStack {
//                    Text("Total")
//                        .font(.headline)
//                    Spacer()
//                    Text("5.000 RUB")
//                        .font(.headline)
//                        .bold()
//                }
//                ForEach(data, id: \.name) { category, amount in
//                    HStack {
//                        Text("\(category)")
//                        Spacer()
//                        Text("\(amount)")
//                    }
//                }
            }
        }
    }
}

#Preview {
    StatisticsView()
        .environmentObject(CarViewModel())
        .environmentObject(RepairViewModel())
}
