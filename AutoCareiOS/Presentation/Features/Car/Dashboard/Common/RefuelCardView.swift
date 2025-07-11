//
//  DashboardRefuelCardView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 23.05.2025.
//

import SwiftUI

struct RefuelCardView: View {
    @EnvironmentObject var carViewModel: CarViewModel
    @EnvironmentObject var repairViewModel: RepairViewModel
    
    @State var liters: String = ""
    @State var date: Date = Date()

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "fuelpump.fill")
                .font(.title3)
                .foregroundStyle(.orange)
            VStack(alignment: .leading, spacing: 2) {
                Text("Last Refuel")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(liters) L")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(relativeDateString(from: date))
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .frame(height: 65)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.clear.opacity(0.3), Color.gray.opacity(0.2)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.01), lineWidth: 1)
                )
        .cornerRadius(16)
        .shadow(radius: 3)
        .contentShape(Rectangle())
        .onAppear(perform: updateRefuelData)
        .onChange(of: carViewModel.selectedCar) { _ in updateRefuelData() }
    }

    private func updateRefuelData() {
        if let car = carViewModel.selectedCar {
            let repairs = repairViewModel.getLastRefuel(repairs: repairViewModel.repairs)
            liters = repairs.litres
            date = repairs.date
        }
    }

    private func relativeDateString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

//#Preview {
//    RefuelCardView(liters: "35.7", date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!)
//        .environmentObject(CarViewModel())
//}
