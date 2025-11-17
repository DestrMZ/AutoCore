//
//  EmptyRepair.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 01.08.2025.
//

import SwiftUI

struct EmptyRepairView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                Image(systemName: "wrench.and.screwdriver")
                    .font(.system(size: 40, weight: .semibold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.secondary)

                Text("No repairs yet")
                    .font(.headline)

                Text("Track costs and history. Add your first repair to get started.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .padding(20)
            .frame(maxWidth: 360)
            .shadow(radius: 2, y: 1)
            .padding()
        }
    }
}

#Preview {
    EmptyRepairView()
}
