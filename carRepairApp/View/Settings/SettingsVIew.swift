//
//  SettingsVIew.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 12.10.2024.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    
    var body: some View {
        Text("Settings View")
    }
}

#Preview {
    SettingsView()
}
