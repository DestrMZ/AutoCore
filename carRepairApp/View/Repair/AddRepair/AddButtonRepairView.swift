//
//  AddButtonRepairView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 16.10.2024.
//

import SwiftUI

struct AddButtonRepairView: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        Button(action: {
            isPresented = true
        }) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.green)
//                .shadow(radius: 10)
        }
    }
}

#Preview {
    AddButtonRepairView(isPresented: .constant(false))
}
