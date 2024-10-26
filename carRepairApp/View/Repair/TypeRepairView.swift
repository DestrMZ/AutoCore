//
//  TypeRapirView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 25.10.2024.
//

import SwiftUI

struct TypeRepairView: View {
    
    @EnvironmentObject var repairViewModel: RepairViewModel
    
    var columns = [
        GridItem(.adaptive(minimum: 85))
    ]
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 45) {
                Text("Choice type repair")
                    .font(.title)
                    .bold()
                    .padding(.top, 20)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 25) {
                        ForEach(RepairCategory.allCases, id: \.self) { repairType in
                            Button(action: {
                                repairViewModel.repairCategory = repairType
//                                dismiss()
                            }) {
                                VStack {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 80, height: 80)
                                        .overlay(
                                            Image(repairType.imageIcon)
                                                .resizable()
                                                .scaledToFit()
                                                .padding()
                                                .foregroundStyle(Color.black)

                                        )
                                        .clipShape(Circle())
                                    Text(repairType.rawValue)
                                        .foregroundColor(.black)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding(8)
                                        .background(Color.white.opacity(0.8))
                                        .cornerRadius(25)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TypeRepairView()
        .environmentObject(RepairViewModel())
}
