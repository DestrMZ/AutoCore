//
//  LicensePlateView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 11.06.2025.
//

import SwiftUI

struct LicensePlateView: View {
    
    var stateNumber: String
    
    var stateNumberFormatter: (String, String) {
        stateNumber.formatLicensePlateForDisplay()
    }

    var body: some View {
        if stateNumber == "Empty" {
            Text("No license plate")
                .font(.subheadline.bold())
                .foregroundStyle(.white.opacity(0.6))
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.05))
                )
        } else {
            HStack(spacing: 4) {
                Text(stateNumberFormatter.0)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                
                Divider()
                    .frame(height: 16)
                    .overlay(Color.white.opacity(0.6))
                
                Text(stateNumberFormatter.1)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white.opacity(0.1))
            )
        }
    }
}

extension String {
    func formatLicensePlateForDisplay() -> (number: String, region: String) {
        let stateNumber = self.uppercased().replacingOccurrences(of: " ", with: "")
        
        let letter = stateNumber.prefix(1)
        let number = stateNumber.dropFirst(1).prefix(3)
        let letter2 = stateNumber.dropFirst(4).prefix(2)
        let region = stateNumber.dropFirst(6)
        
        let result = ("\(letter) \(number) \(letter2)", "\(region)")
        return result
    }
}


#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        LicensePlateView(stateNumber: "О611ТВ790")
    }
}
