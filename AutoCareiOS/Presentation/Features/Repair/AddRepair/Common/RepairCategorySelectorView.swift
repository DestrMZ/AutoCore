//
//  RepairCategorySelectorView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 19.07.2025.
//

import Foundation
import SwiftUI


struct RepairCategorySelectorView: View {
    
    @Binding var selectedCaregory: RepairCategory
    
    var body: some View {
        
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 20) {
            ForEach(RepairCategory.allCases, id: \.self) {category in
                Button(action: {
                    selectedCaregory = category
                }) {
                    VStack {
                        Image(category.imageIcon)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(selectedCaregory == category ? Color.primary : Color.secondary)
                        
                        Text(NSLocalizedString(category.rawValue, comment: ""))
                            .font(.caption)
                            .foregroundColor(selectedCaregory == category ? Color.primary : Color.secondary)
                    }
                }
            }
        }
    }
}
