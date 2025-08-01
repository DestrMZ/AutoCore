//
//  EmptyRepair.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 01.08.2025.
//

import Foundation
import SwiftUI


struct EmptyRepair: View {
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(spacing: 8) {
                Text("🛠️ Go add your first expanses?")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 1)
                Text(NSLocalizedString("car_expenses_control", comment: ""))
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .padding(.top, 300)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
