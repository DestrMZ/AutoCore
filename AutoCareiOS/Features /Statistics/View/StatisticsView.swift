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
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    @State var selectPeriod: FilterDate = .allTime
    
    @State var startDate: Date? = nil
    @State var endDate: Date? = nil
    
    @State var isDatePickerVisabillity: Bool = false
    
    var selectedCar: Car? {
        carViewModel.selectedCar
    }
    
    var repairs: [Repair] {
        repairViewModel.repairArray
    }
    
    var statsCalc: RepairStatsCalculator {
        RepairStatsCalculator(repairs: repairs)
    }
    
    var dictRepairs: [String: Int] {
        guard selectedCar != nil else { return [:] }
        return statsCalc.getRepairsCategoriesAndAmount(selectedPeriod: selectPeriod)
    }
        
    var entityForPie: [PieChartDataEntry] {
        guard selectedCar != nil else { return [] }
        return statsCalc.getRepairCategoriesAndAmounts(selectPeriod: selectPeriod)
    }
    
    var entityForBar: [BarChartDataEntry] {
        guard selectedCar != nil else { return [] }
        return statsCalc.getMonthlyExpenses()
    }
    
    var entityForLine: [ChartDataEntry] {
        guard selectedCar != nil else { return [] }
        return statsCalc.getTrendLine()
    }
    
    var body: some View {
        if carViewModel.allCars.isEmpty {
            
            EmptyCarList()
            
        } else {
            VStack {
                TabView {
                    if let car = selectedCar {
                        UIKitPieChartView(selectedCar: car, entity: entityForPie)
                            .frame(width: 400, height: 350)
                            .padding(.bottom, 30)
                            .tag(0)
                        
                        UIKitCombinedChartView(selectedCar: car, entityForBar: entityForBar, entityForLine: entityForLine)
                            .frame(width: 400, height: 350)
                            .padding(.bottom, 30)
                            .tag(1)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
                
                
                HStack(alignment: .center) {
                    Picker("Select period: ", selection: $selectPeriod) {
                        Text("Week").tag(FilterDate.week)
                        Text("Month").tag(FilterDate.month)
                        Text("Year").tag(FilterDate.year)
                        Text("All time").tag(FilterDate.allTime)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 10)
                    
                    Button(action: {
                        isDatePickerVisabillity.toggle()
                    }) {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                }
                .padding(.horizontal, 25)
                
                
                List {
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        if selectedCar != nil {
                            Text("\(statsCalc.totalAmountFilter(selectedPeriod: selectPeriod)) \(settingsViewModel.currency)")
                                .font(.headline)
                                .bold()
                        }
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
                            
                            Text("\(NSLocalizedString(category, comment: ""))")
                                .font(.subheadline)
                            Spacer()
                            Text("\(amount)")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .onAppear {
                if let car = selectedCar {
                    repairViewModel.getAllRepairs(for: car)
                }
            }
            .sheet(isPresented: $isDatePickerVisabillity) {
                SelectDateView(
                    startDate: $startDate,
                    endDate: $endDate,
                    onDateSelected: {
                        selectedStart, selectedEnd in
                        selectPeriod = .custom(startDate: selectedStart ?? Date(), endDate: selectedEnd ?? Date())
                        print(startDate ?? Date())
                        print(endDate ?? Date())
                    })
            }
        }
    }
}

#Preview {
    StatisticsView()
        .environmentObject(CarViewModel())
        .environmentObject(RepairViewModel())
}
