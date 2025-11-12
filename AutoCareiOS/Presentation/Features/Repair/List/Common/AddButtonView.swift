//
//  AddButtonView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 31.07.2025.
//

import Foundation
import SwiftUI


struct AddButtonView: View {
    
    @Binding var isPresented: Bool

    var body: some View {
        Button(action: {
            isPresented = true
        }) {
            if #available(iOS 26.0, *) {
                Image(systemName: "plus")
                    .frame(width: 60.0, height: 60.0)
                    .font(.system(size: 36))
                    .glassEffect()
            } else {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.primary)
            }
        }
    }
}


#Preview {
    AddCarView()
}
