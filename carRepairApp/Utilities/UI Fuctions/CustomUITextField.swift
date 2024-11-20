//
//  CustomUITextField.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 11.10.2024.
//

import SwiftUI

struct CustomUITextField: View {
    @Binding var text: String
    @FocusState var isActive
    
    var title: String
    var body: some View {
        
        ZStack(alignment: .leading) {
            TextField("", text: $text)
                .padding(.leading)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .focused($isActive)
                .background(.secondary)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            Text(title)
                .padding(.horizontal)
                .offset(y: (isActive || !text.isEmpty) ? -40 : 0)
                .foregroundStyle(isActive ? .gray : .white)
                .animation(.spring, value: isActive)
        }.padding(.horizontal, 35)
    }
}

struct SwiftUIView: View {
    @State var email = ""
    @State var name = ""

    var body: some View {
        VStack(spacing: 45) {
            CustomUITextField(text: $email, title: "Email")
            CustomUITextField(text: $name, title: "Name")
        }
    }
}

#Preview {
    SwiftUIView()
}
