//
//  PartsView.swift
//  AutoCare
//
//  Created by Ivan Maslennikov on 12.04.2025.
//

import SwiftUI


struct PartsView: View {
    @Binding var isRepairEditing: Bool
    @Binding var partsList: [Part]
    
    @State private var copiedPartArticle: String = ""
    @State private var newPart: Part = Part(article: "", name: "")
    
    let repair: RepairModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Parts", systemImage: "wrench.and.screwdriver.fill")
                .font(.headline)
            
            if isRepairEditing {
                ForEach(partsList.indices, id: \.self) { index in
                    HStack {
                        PartsRowView(part: $partsList[index])
                        Button(action: {
                            partsList.remove(at: index)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundStyle(.red)
                        }
                    }
                }
                
                HStack {
                    PartsRowView(part: $newPart)
                    Button(action: {
                        guard !newPart.article.isEmpty, !newPart.name.isEmpty else { return }
                        partsList.append(newPart)
                        newPart = Part(article: "", name: "")
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
            } else {
                #warning("Show parts from repair")
                let parts = repair.parts
                if !parts.isEmpty {
                    ForEach(parts.sorted(by: { $0.key < $1.key }), id: \.key) { part in
                        HStack {
                            Button(action: {
                                copyToClipboard(text: part.key)
                                provideHapticFeedbackHeavy()
                                copiedPartArticle = part.key
                            }) {
                                Text(part.key)
                                    .font(.system(.body, design: .monospaced))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.secondary.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            }

                            Spacer()

                            Text(part.value)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 8)
                    }
                } else {
                    Text("No parts recorded")
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
