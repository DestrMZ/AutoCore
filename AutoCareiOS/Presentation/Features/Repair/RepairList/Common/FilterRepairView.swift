//
//  FilterRepairView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 31.07.2025.
//

import Foundation
import SwiftUI


struct FilterRepairView: View {
    
    @Binding var searchText: String
    
    @State private var searchBarHeight: CGFloat = 0
    
    var body: some View {
        SearchBar(text: $searchText, keyboardHeight: $searchBarHeight, placeholder: NSLocalizedString("Search repair", comment: ""))
    }
}
