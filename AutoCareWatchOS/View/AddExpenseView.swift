//
//  AddExpenseView.swift
//  AutoCareWatchOS
//
//  Created by Ivan Maslennikov on 11.03.2025.
//

import SwiftUI

struct AddExpenseView: View {
    
    @EnvironmentObject var viewModel: ExpensesViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Button(action: {
                viewModel.navigationPath.append(ExpenseStep.enterTitle)
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 85))
                    .foregroundStyle(.black)
                    .padding(15)
                    .background(Color.primary)
                    .clipShape(Circle())
            }
            .buttonStyle(PlainButtonStyle())
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.resetField()
        }
    }
}

#Preview {
    AddExpenseView()
        .environmentObject(ExpensesViewModel())
}
