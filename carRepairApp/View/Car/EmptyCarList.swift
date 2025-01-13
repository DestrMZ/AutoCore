//
//  EmptyCarList.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 04.01.2025.
//


import SwiftUI


struct EmptyCarList: View {
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
    EmptyCarList()
}
