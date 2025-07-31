//
//  EmptyRepairView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 31.07.2025.
//

import Foundation
import SwiftUI


struct EmptyRepairView: View {
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Please, go back to the selection menu ")
            + Text(Image(systemName: "car.2"))
                    .font(.title2)
                    .foregroundColor(.secondary)
                + Text(" and add your first vehicle.")
            Spacer()
        }
        .font(.headline)
        .padding(.horizontal, 25)
        .multilineTextAlignment(.center)
    }
}

#Preview {
    EmptyRepairView()
}
