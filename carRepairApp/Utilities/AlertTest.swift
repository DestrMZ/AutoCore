//
//  AlertTest.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 20.11.2024.
//

import SwiftUI

struct AlertTest: View {
    
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack {
            Button("Go") {
                showAlert = true
            }
            .toast(isPresenting: $showAlert) {
                AlertToast(displayMode: .banner(.slide), type: .complete(.black), title: "Okey", style: .style(backgroundColor: .blackRed.opacity(0.8), titleColor: .black, subTitleColor: .black, titleFont: .headline, subTitleFont: .subheadline))
                
            }
        }
        
    }
}

#Preview {
    AlertTest()
}
