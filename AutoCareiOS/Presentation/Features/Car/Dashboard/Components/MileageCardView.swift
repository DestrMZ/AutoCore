//
//  DashboardMileageCardView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 23.05.2025.
//

import SwiftUI

struct MileageCardView: View {
    
    @ObservedObject var dashboardViewModel: DashboardViewModel
    
    @State var showSheetUpdateMileage: Bool = false
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Mileage")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(dashboardViewModel.currentMileage) mi")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
            Spacer()
            Button(action: {
                showSheetUpdateMileage = true
            }) {
                Image(systemName: "speedometer")
                    .font(.title3)
                    .foregroundStyle(.primary)
            }
            .buttonStyle(.plain)
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
        .sheet(isPresented: $showSheetUpdateMileage) {
            SheetUpdateMileageView(dashboardViewModel: dashboardViewModel)
                .presentationDetents([.fraction(0.20)])
                .presentationDragIndicator(.visible)
        }
    }
}

//#Preview {
//    MileageCardView()
//        .environmentObject(CarViewModel())
//}
