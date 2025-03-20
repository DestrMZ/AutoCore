//
//  ExpenseAmountInputView.swift
//  AutoCareWatchOS
//
//  Created by Ivan Maslennikov on 11.03.2025.
//

import SwiftUI

struct ExpenseAmountInputView: View {
    
    @EnvironmentObject private var viewModel: ExpensesViewModel
    
    @State private var amount: Int32 = 0
    
    private let amountRange = stride(from: 0, through: 10000, by: 100).map { Int32($0) }

    var body: some View {
    
        VStack(spacing: 15) {

            Picker("", selection: $amount) {
                ForEach(amountRange, id: \.self) { amount in
                    Text("\(amount) RUB")
                }
            }
            .pickerStyle(.wheel)
            .padding(.horizontal)
            .onChange(of: amount) { newValue, _ in
                WKInterfaceDevice.current().play(.click)
            }
            
            Button("Next") {
                viewModel.amount = amount
                viewModel.navigationPath.append(ExpenseStep.selectCategory)
            }
            .padding()
            .font(.system(.subheadline, design: .rounded))
            .frame(maxWidth: .infinity, maxHeight: 50)
            .foregroundStyle(.black)
            .background(Color.primary)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .buttonStyle(PlainButtonStyle())
            
        }
        .padding(10)
    }
}

#Preview {
    NavigationStack {
        ExpenseAmountInputView()
            .environmentObject(ExpensesViewModel())
    }
}
