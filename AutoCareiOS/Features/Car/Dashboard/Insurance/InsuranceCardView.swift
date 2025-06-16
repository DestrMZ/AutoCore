////
////  DashboardInsuranceCardView.swift
////  AutoCareiOS
////
////  Created by Ivan Maslennikov on 23.05.2025.
////

import SwiftUI

struct InsuranceCardView: View {
    let insuranceCompany: String
    let insuranceType: String
    let startDate: Date
    let endDate: Date

    private var totalDays: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 1
    }

    private var passedDays: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
    }

    private var remainingDays: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: endDate).day ?? 0
    }

    private var progress: CGFloat {
        min(max(CGFloat(passedDays) / CGFloat(totalDays), 0), 1)
    }

    private var statusText: String {
        if remainingDays > 0 {
            return "\(remainingDays) day\(remainingDays == 1 ? "" : "s") left"
        } else {
            return "Expired \(abs(remainingDays)) day\(abs(remainingDays) == 1 ? "" : "s") ago"
        }
    }

    private var statusColor: Color {
        if remainingDays > 30 {
            return .green
        } else if remainingDays > 7 {
            return .yellow
        } else if remainingDays > 0 {
            return .orange
        } else {
            return .red
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Insurance")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(insuranceType)
                            .font(.caption2)
                            .foregroundStyle(.gray)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(5)
                    }

                    Text(insuranceCompany)
                        .font(.headline)

                    Text("\(formatted(startDate)) — \(formatted(endDate))")
                        .font(.caption2)
                        .foregroundStyle(.gray)

                    Text(statusText)
                        .font(.caption2)
                        .foregroundStyle(statusColor)
                }

                Spacer()
            }

            ZStack(alignment: .leading) {
                LinearGradient(
                    colors: [.green, .yellow, .red],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(height: 8)
                .clipShape(Capsule())

                Capsule()
                    .fill(Color.white)
                    .frame(width: 12, height: 12)
                    .offset(x: (progress * UIScreen.main.bounds.width * 0.8) - 6)
                    .shadow(radius: 1)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
   InsuranceCardView(
       insuranceCompany: "Ingosstrakh",
       insuranceType: "OSAGO",
       startDate: Calendar.current.date(byAdding: .month, value: -5, to: Date())!,
       endDate: Calendar.current.date(byAdding: .month, value: 1, to: Date())!
   )
   .padding()
   .background(Color.black)
}
