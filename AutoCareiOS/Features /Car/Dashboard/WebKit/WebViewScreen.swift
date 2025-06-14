//
//  WebViewScreen.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 11.06.2025.
//

import SwiftUI

struct WebViewScreen: View {
    @State private var showWebView = false

    var body: some View {
        VStack {
            Button(action: {
                showWebView = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.red)
                        .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Text("Traffic Fine Check")
                            .font(.headline)
                        Text("GIBDD Official Site")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .shadow(radius: 3)
            }
            .sheet(isPresented: $showWebView) {
                NavigationStack {
                    WebView(url: URL(string: "https://avtocod.ru/proverka-shtrafov-gibdd")!)
                        .navigationTitle("Traffic Fine Check")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close") {
                                    showWebView = false
                                }
                            }
                        }
                }
            }
        }
        .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.clear.opacity(0.3), Color.gray.opacity(0.2)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.01), lineWidth: 1)
                )
    }
}


#Preview {
    WebViewScreen()
}
