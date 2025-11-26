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
    
    var body: some View {
        VStack(alignment: .leading) {
            Section("Parts:") {
                ForEach(addRepairViewModel.parts.indices, id: \.self) { index in
                    HStack {
                        PartsRowView(part: $addRepairViewModel.parts[index])
                        
                        Spacer()
                        
                        if addRepairViewModel.parts.count > 1 {
                            Button {
                                addRepairViewModel.removePart(at: IndexSet([index]))
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundStyle(.red)
                                    .font(.title2)
                            }
                        }
                    }
                    .padding(.vertical, 2)
                }
                
                Button {
                    addRepairViewModel.addPart()
                } label: {
                    Label("Добавить запчасть", systemImage: "plus.circle")
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 8)
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
