//
//  EmptyRepairView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 31.07.2025.
//

import Foundation
import SwiftUI


struct EmptyCarsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "car.2.fill")
                .font(.system(size: 40, weight: .semibold))
                .foregroundColor(.secondary)
            
            Text("No vehicles yet")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Add your first car in the selection menu.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(20)
        .frame(maxWidth: 360)
        .shadow(radius: 2, y: 1)
        .padding()
    }
}

#Preview {
    EmptyCarsView()
}

