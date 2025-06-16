//
//  AddNewCarView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 01.06.2025.
//

import SwiftUI

struct AddPlaceholderCarView: View {
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.gray.opacity(0.2)
                
                Image(systemName: "plus.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .frame(width: UIScreen.main.bounds.width * 0.2)

            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.95, height: 500)
        .cornerRadius(32)
    }
}

#Preview {
    AddPlaceholderCarView()
}


