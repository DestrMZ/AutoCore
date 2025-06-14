//
//  MaintenanceView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 30.05.2025.
//

import SwiftUI

struct ServiceCardView: View {
    let title: String = "ТО-2"
    let subtitle: String = "Через 2,450 км"
    let progress: Double = 0.8 // от 0 до 1

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 50, height: 50)

                    Text("\(Int(progress * 100))%")
                        .foregroundColor(.primary)
                        .font(.headline)
                }
            }

            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .primary))
                .background(
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 4)
                )
                .frame(height: 4)

            Button(action: {
                // Действие по нажатию
            }) {
                Text("Запланировать")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
    }
}

#Preview {
    ServiceCardView()
//        .preferredColorScheme(.dark)
}
