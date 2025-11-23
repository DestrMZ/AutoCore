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
    let notificationDate: Date?   // ← добавляем
    
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
        if remainingDays > 30 { .green }
        else if remainingDays > 7 { .yellow }
        else if remainingDays > 0 { .orange }
        else { .red }
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
                
                // КОЛОКОЛЬЧИК — появляется только если есть уведомление
                if notificationDate != nil {
                    Image(systemName: "bell.fill")
                        .font(.title3)
                        .foregroundStyle(.yellow)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
//                        .symbolEffect(.pulse, options: .repeating) // iOS 17+ — лёгкая анимация
                        .transition(.scale.combined(with: .opacity))
                }
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

// MARK: - Preview
#Preview {
    InsuranceCardView(
        insuranceCompany: "Ingosstrakh",
        insuranceType: "КАСКО",
        startDate: Calendar.current.date(byAdding: .month, value: -3, to: Date())!,
        endDate: Calendar.current.date(byAdding: .month, value: 6, to: Date())!,
        notificationDate: Date().addingTimeInterval(30*86400) // с уведомлением
    )
    .padding()
    .background(Color.black)
}

#Preview("Без уведомления") {
    InsuranceCardView(
        insuranceCompany: "Rosgosstrakh",
        insuranceType: "OSAGO",
        startDate: Date().addingTimeInterval(-100*86400),
        endDate: Date().addingTimeInterval(200*86400),
        notificationDate: nil // без уведомления
    )
    .padding()
    .background(Color.black)
}

