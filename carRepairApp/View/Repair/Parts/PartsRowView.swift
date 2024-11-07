//
//  PartsRowVie.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 30.10.2024.
//

import SwiftUI

struct PartsRowView: View {
    @Binding var part: Parts
    var addPart: (Parts) -> Void
    
    var body: some View {
        HStack {
            TextField("Article", text: $part.article)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: .infinity)
            
            TextField("Name", text: $part.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 8)
        .onChange(of: part) { _, _ in
            addPart(part) // Обновляем словарь при изменении данных
        }
    }
}
