//
//  AlertTest.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 20.11.2024.
//

import SwiftUI
//
struct AlertTest: View {
    
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack {
            Button("Go") {
                showAlert = true
            }
            .toast(isPresenting: $showAlert) {
                AlertToast(displayMode: .hud, type: .complete(.white), title: "Image successfully uploaded", style: .style(backgroundColor: .black.opacity(0.8), titleColor: .white, subTitleColor: .black, titleFont: .headline, subTitleFont: .subheadline))
                
            }
        }
    }
}

#Preview {
    AlertTest()
}
