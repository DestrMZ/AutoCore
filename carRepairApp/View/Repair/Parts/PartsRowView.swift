//
//  PartsRowVie.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 30.10.2024.
//

import SwiftUI

struct PartsRowView: View {
    @Binding var part: Part
    
    var body: some View {
        HStack {
            TextField("Article", text: $part.article)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: .infinity)
//                .foregroundStyle(.secondary)
            
            TextField("Name", text: $part.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: .infinity)
//                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }
}

//#Preview {
//    
//    @State var part = Part(article: "123123", name: "Oil")
//    PartsRowView(part: $part)
//    
//}
