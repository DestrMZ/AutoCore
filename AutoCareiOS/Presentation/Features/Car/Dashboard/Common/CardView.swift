//
//  DashboardCardView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 23.05.2025.
//

import SwiftUI

struct CardView: View {
    let car: Car

    var body: some View {
        VStack(spacing: 25) {
            InfoCardRow(label: "Year", value: "\(car.year)")
            InfoCardRow(label: "Engine", value: "\(car.engineType ?? "Gasoline")")
            InfoCardRow(label: "Transmission", value: "\(car.transmissionType ?? "Automatic")")
        }
        .padding()
//        .background(.ultraThinMaterial)
//        .cornerRadius(20)
//        .overlay(
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(Color.white.opacity(0.2), lineWidth: 1)
//        )
//        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
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
                        .stroke(Color.white.opacity(0.05), lineWidth: 1)
                )
    }
}

private struct InfoCardRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    let car = Car(context: CoreDataStack.shared.context)
    car.nameModel = "Elantra AD 2.0"
    car.year = 2016
    car.engineType = "Gasoline"
    
    return CardView(car: car)
}
