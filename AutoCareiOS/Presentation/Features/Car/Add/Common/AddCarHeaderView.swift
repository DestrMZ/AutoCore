//
//  AddCarHeaderView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 16.11.2025.
//

import SwiftUI

struct AddCarHeaderView: View {
    var body: some View {
        HStack {
            Text("Add")
                .font(.title)
                .bold()
                .foregroundStyle(.primary)
                .padding(.top, 10)
            Image("newCar")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
        }
    }
}

#Preview {
    AddCarHeaderView()
}
