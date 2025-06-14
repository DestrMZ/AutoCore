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
    
    @State var copiedPartArticle: String = ""
    @State var newPart: Part = Part(article: "", name: "")
    
    let repair: Repair
 
    var body: some View {
        VStack(alignment: .leading ,spacing: 12) {
            Label("Parts", systemImage: "wrench.and.screwdriver.fill")
                .font(.headline)
            
            if let parts = repair.parts {
                
                if isRepairEditing { // If editing mode
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
                            partsList.append(newPart)
                            newPart = Part(article: "", name: "")
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                } else {
                    ForEach(Array(parts.sorted { $0.key < $1.key }), id: \.key) { part in
                        
                        HStack {
                            Button(action: {
                                copyToClipboard(text: part.key)
                                provideHapticFeedbackHeavy() // Haptic feedback
                                
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
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)

    }
}


#Preview {
    let context = CoreDataStack.shared.context
    let repair = Repair(context: context)
    repair.partReplaced = "Brake pads"
    repair.amount = 100_000
    repair.repairMileage = 123_000
    repair.repairDate = Date()
    repair.notes = "Brake pads were replaced"
    repair.parts = ["EF31": "Generator", "E531": "Starter"]
    repair.repairCategory = "Service"
    repair.litresFuel = 10
    
    return PartsView(
        isRepairEditing: .constant(false),
        partsList: .constant([Part(article: "EF31", name: "Generator")]),
        repair: repair
    )
    .environmentObject(RepairViewModel())
    .environmentObject(SettingsViewModel())
}
