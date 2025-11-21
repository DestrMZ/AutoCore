//
//  DashboardRefuelCardView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 23.05.2025.
//
//

import SwiftUI

struct RefuelCardView: View {
    
    @ObservedObject var dashboardViewModel: DashboardViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "fuelpump.fill")
                .font(.title3)
                .foregroundStyle(.orange)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Last Refuel")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if dashboardViewModel.lastRefuelLiters != "—" {
                    Text(dashboardViewModel.lastRefuelLiters)
                        .font(.title3.bold())
                        .foregroundStyle(.primary)
                    
                    Text(dashboardViewModel.lastRefuelAgo)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text("No refuels yet")
                        .font(.headline)
                        .foregroundStyle(.secondary.opacity(0.7))
                }
            }
            
            Spacer()
        }
        .frame(height: 72)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.clear.opacity(0.3), Color.gray.opacity(0.15)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 6, y: 4)
        .contentShape(Rectangle())
    }
}
//
//#Preview {
//    RefuelCardView(dashboardViewModel: .init(
//        carStore: .init(carUseCase: MockCarUseCase()),
//        repairStore: .init(repairUseCase: MockRepairUseCase())
//    ))
//    .padding()
//    .background(Color.black)
//}
