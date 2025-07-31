//
//  RepairPartsListView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 19.07.2025.
//

import Foundation
import SwiftUI


struct RepairPartsListView: View {
    
    @ObservedObject var addRepairViewModel: AddRepairViewModel
    @Binding var parts: [Part]

    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Parts:")
            ForEach(parts.indices, id: \.self) { index in
                HStack {
                    PartsRowView(part: $parts[index])
                    
                    if index == 0 {
                        Button(action: {
                            addRepairViewModel.addPart(for: &parts)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(.green)
                        }
                    } else {
                        Button(action: {
                            addRepairViewModel.removePart(for: &parts, to: index)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                        Button(action: {
                            hideKeyboard()
                        }) {
                            Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }
        }
    }
}
