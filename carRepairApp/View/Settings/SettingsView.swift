//
//  SettingsView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 19.10.2024.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var enableNotification: Bool = true
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            VStack(alignment: .center, spacing: 5) {
                Image("avocado")
                    .resizable()
                    .scaledToFit()
                    .padding(.top)
                    .frame(width: 100, height: 100, alignment: .center)
                    .shadow(color: Color("ColorBlackTransparentLight"), radius: 8, x: 0, y: 4)
                
                Text("Avocados".uppercased())
                    .font(.system(.title, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(Color("ColorGreenAdaptive"))
            }
            .padding()
            
            Form {
                
                Section(header: Text("General Settings")) {
                    Toggle(isOn: $enableNotification) {
                        Text("Enable notifiacation")
                    }
                    
                    
                    Section(header: Text("Application")) {
                        if enableNotification {
                            HStack {
                                Text("Product").foregroundColor(Color.gray)
                                Spacer()
                                Text("AutoCare")
                            }
                            HStack {
                                Text("Compatibility").foregroundColor(Color.gray)
                                Spacer()
                                Text("iPhone iOS 16+")
                            }
                            HStack {
                                Text("Developer & Designer").foregroundColor(Color.gray)
                                Spacer()
                                Text("Ivan Maslennikov")
                            }
                            HStack {
                                Text("Website").foregroundColor(Color.gray)
                                Spacer()
                                Text("https://github.com/DestrMZ")
                            }
                            HStack {
                                Text("Version").foregroundColor(Color.gray)
                                Spacer()
                                Text("0.1.0")
                            }
                        } else {
                            HStack {
                                Text("Personal message").foregroundColor(Color.gray)
                                Spacer()
                                Text("👍 Happy Coding!")
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: 640)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
