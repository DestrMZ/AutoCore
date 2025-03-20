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
    
    var dictRepairs: [String: Int] {
        guard let car = selectedCar else { return [:] }
        return repairViewModel.getRepairsCategoriesAndAmount(for: car, selectedPeriod: selectPeriod)
    }
        
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
                        if let car = selectedCar {
                            Text("\(repairViewModel.totalAmountFilter(for: car, selectedPeriod: selectPeriod)) \(settingsViewModel.currency)")
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
