//
//  ExpenseTitleInputView.swift
//  AutoCareWatchOS
//
//  Created by Ivan Maslennikov on 11.03.2025.
//

import SwiftUI

struct ExpenseTitleInputView: View {
    
    @EnvironmentObject var viewModel: ExpensesViewModel
    
    @State var nameRepair: String = ""
    
    var body: some View {

        VStack {
            TextField("What did they do?", text: $nameRepair)
                .padding(5)
            
            Button(action: {
                if !nameRepair.isEmpty {
                    viewModel.nameRepair = nameRepair
                    viewModel.navigationPath.append(ExpenseStep.enterAmount)
                }
                
            }) {
                Text("Next")
                    .padding()
                    .font(.system(.subheadline, design: .rounded))
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .foregroundStyle(.black)
                    .background(Color.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(5)
            .buttonStyle(PlainButtonStyle())
            .disabled(nameRepair.isEmpty)

        }
    }
}

#Preview {
    ExpenseTitleInputView()
        .environmentObject(ExpensesViewModel())
}
