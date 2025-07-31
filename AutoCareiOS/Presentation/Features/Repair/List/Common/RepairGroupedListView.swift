//
//  RepairGroupedListView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 31.07.2025.
//

import Foundation
import SwiftUI

struct RepairGroupedListView: View {
    
    @ObservedObject var listViewModel: RepairListViewModel
    
    @EnvironmentObject var sharedRepairStore: SharedRepairStore
    @EnvironmentObject var sharedCarStore: SharedCarStore
        
    @Binding var searchText: String
    @Binding var showTapBar: Bool
    
    private var filteredRepairs: [RepairModel] {
            if searchText.isEmpty {
                return sharedRepairStore.repairs.reversed()
            } else {
                return sharedRepairStore.repairs.filter {
                    $0.partReplaced.lowercased().contains(searchText.lowercased())
                }
            }
        }
    
    var body: some View {
           let groups = listViewModel.fetchRepairsGroupByMonth(for: filteredRepairs)

           ForEach(groups, id: \.id) { group in
               VStack(alignment: .leading, spacing: 0) {
                   HStack {
                       Text(group.monthTitle)
                           .font(.headline)
                       Spacer()
                       Text("\(String(format: "%.2f", group.totalAmount)) $")
                           .font(.subheadline)
                           .bold()
                   }
                   .padding(5)

                   Divider()

                   ForEach(group.repairs) { repair in
                       if let car = sharedCarStore.selectedCar {
                           NavigationLink(
                               destination: DetailRepairView(repair: repair, car: car)
                                   .onAppear { showTapBar = false }
                                   .onDisappear { showTapBar = true }
                           ) {
                               ListRowView(repair: repair)
                                   .padding(.vertical, 7)
                           }
                           .contextMenu {
                               Button("Delete repair") {
                                   listViewModel.deleteRepair(repair: repair)
                               }
                           }
                       }
                   }
               }
           }
       }
   }
