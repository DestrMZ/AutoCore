//
//  FinalExpensView.swift
//  AutoCareWatchOS
//
//  Created by Ivan Maslennikov on 15.03.2025.
//

import SwiftUI

struct FinalExpensView: View {
    
    @EnvironmentObject var viewModel: ExpensesViewModel
    
    var body: some View {
        
        VStack {
            
            VStack(alignment: .leading) {
                Form {
                    VStack(alignment: .leading ,spacing: 0) {
                        Text("\(viewModel.nameRepair)")
                            .font(.headline)
                            .lineLimit(2)
                        
                        Text("\(viewModel.category.rawValue)")
                            .font(Font.system(size: 13))
                            .foregroundColor(.gray)
                        Text("\(viewModel.amount) $")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 2)
            
            Button("Save") {
                WKInterfaceDevice.current().play(.success)
                viewModel.saveRepair()
                viewModel.navigationPath.append(ExpenseStep.successfull)
                
            }
            .font(.system(.subheadline, design: .rounded))
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(Color.green)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .buttonStyle(PlainButtonStyle())
        }
        .padding(10)
        .navigationTitle("Detail:")
    }
}

#Preview {
    
    let viewModel = ExpensesViewModel()
    viewModel.amount = 100
    viewModel.nameRepair = "Change break"
    viewModel.category = RepairCategoryForWatchOS.service
    
    return FinalExpensView()
        .environmentObject(viewModel)
}
