//
//  SettingsViewModel.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 08.01.2025.
//

import Foundation
import SwiftUI


class SettingsViewModel: ObservableObject {
    
    @AppStorage("theme") var theme: String = "System"
    @AppStorage("distanceUnit") var distanceUnit: String = "km"
    @AppStorage("currency") var currency: String = "USD"
    @AppStorage("language") var language: String = "English" {
        didSet {
            showRestartingApp = true
            setLanguage()
        }
    }
    @Published var showRestartingApp: Bool = false
    
    func changeColorScheme() -> ColorScheme? {
        switch theme {
        case "Dark":
            return .dark
        case "Light":
            return .light
        default:
            return nil
        }
    }
    
    private func exportDate(car: Car, repairs: Repair) /*-> URL?*/ {
        
    }
    
    private func importDate(date: URL) {
        
    }
    
    private func resetSettings() { }
    
    private func setLanguage() {
        let selectedLanguage = language == "Russian" ? "ru" : "en"

        UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
    }
}
