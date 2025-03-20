//
//  SettingsView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 19.10.2024.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    @State private var selectedCarForExportDate: Car?
    
    var body: some View {
        
        Form {
            Section(header: Text("Appearance")) {
                Picker("Theme", selection: $settingsViewModel.theme) {
                    Text("Dark").tag("Dark")
                    Text("Light").tag("Light")
                    Text("System").tag("System")
                }
            }
            
            Section(header: Text("Language")) {
                Picker("Language", selection: $settingsViewModel.language) {
                    Text("English").tag("English")
                    Text("Russian").tag("Russian")
                }
            }
            
            Section(header: Text("Units of Measurement")) {
                Picker("Currency", selection: $settingsViewModel.currency) {
                    Text("USD").tag("USD")
                    Text("EURO").tag("EURO")
                    Text("RUB").tag("RUB")
                }
                Picker("Distance", selection: $settingsViewModel.distanceUnit) {
                    Text("km").tag("km")
                    Text("miles").tag("miles")
                }
            }
            
            Section(header: Text("Data Management")) {
                Button("Export Data") {
                }
                Button("Import Data") {
                }
            }
            
            Section(header: Text("Notifications (beta)")) {
                Toggle("Enable Notifications", isOn: .constant(false))
            }
            
            Section(header: Text("Support")) {
                Button("Send Feedback") {
                }
            }
        }
        .alert(isPresented: $settingsViewModel.showRestartingApp) {
            Alert(
                title: Text("Language Changed"),
                message: Text("Please restart the app for the changes to take effect."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    SettingsView()
}
