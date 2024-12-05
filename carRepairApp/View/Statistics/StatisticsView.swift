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
    
    @State var selectPeriod: FilterDate = .allTime
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var isDatePickerVisabillity: Bool = false
    
    var selectedCar: Car {
        carViewModel.selectedCar! } // FIXME: Исправить
    
    var dictRepairs: [String: Int] { repairViewModel.getRepairsCategoriesAndAmount(for: selectedCar, selectedPeriod: selectPeriod)}

    var entityForPie: [PieChartDataEntry] {
        if let selectedCar = carViewModel.selectedCar {
            return repairViewModel.getRepairCategoriesAndAmounts(for: selectedCar, selectPeriod: selectPeriod)
        } else { return [] }
    }
    
    var entityForBar: [BarChartDataEntry] {
        if let selectedCar = carViewModel.selectedCar {
            return repairViewModel.getMonthlyExpenses(for: selectedCar)
        } else { return [] }
    }
    
    var entityForLine: [ChartDataEntry] {
        if let selectedCar = carViewModel.selectedCar {
            return repairViewModel.getTrendLine(for: selectedCar)
        } else { return [] }
    }
    
    var body: some View {
        VStack {
            
            TabView {
                UIKitPieChartView(selectedCar: selectedCar, entity: entityForPie)
                    .frame(width: 350, height: 350)
                    .padding(.bottom, 30)
                    .tag(0)
            
                UIKitCombinedChartView(selectedCar: selectedCar, entityForBar: entityForBar, entityForLine: entityForLine)
                    .frame(width: 400, height: 400)
                    .padding(.bottom, 30)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .automatic))
            

           Picker("Select period: ", selection: $selectPeriod) {
               Text("All time").tag(FilterDate.allTime)
               Text("Week").tag(FilterDate.week)
               Text("Month").tag(FilterDate.month)
               Text("Year").tag(FilterDate.year)
               Text("Select").tag(FilterDate.custom(startDate: startDate, endDate: endDate))
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 15)
            
            List {
                HStack {
                    Text("Total")
                        .font(.headline)
                    Spacer()
                    Text("\(repairViewModel.totalAmountFilter(for: selectedCar, selectedPeriod: selectPeriod))")
                        .font(.headline)
                        .bold()
                }
                ForEach(dictRepairs.sorted(by: { $0.value > $1.value } ), id: \.value) { category, amount in
                    HStack {
                        if let repairCategory = RepairCategory(rawValue: category) {
                            Image(repairCategory.imageIcon)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(.primary)
                                .frame(width: 15, height: 15)
                                .padding(.trailing, 8)
                        }
                        
                        Text("\(category)")
                            .font(.subheadline)
                        Spacer()
                        Text("\(amount)")
                            .font(.subheadline)
                    }
                }
            }
        }
        .onAppear {
            repairViewModel.updateRepairs(for: selectedCar)
        }
    }
}

#Preview {
    StatisticsView()
        .environmentObject(CarViewModel())
        .environmentObject(RepairViewModel())
}
