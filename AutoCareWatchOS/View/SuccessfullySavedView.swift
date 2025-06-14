//
//  SuccessfullySavedView.swift
//  AutoCareWatchOS
//
//  Created by Ivan Maslennikov on 16.03.2025.
//

import SwiftUI

struct SuccessfullySavedView: View {
    
    @EnvironmentObject var viewModel: ExpensesViewModel
    
    var body: some View {
    
        VStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.white)
            
            Text("Successfully saved!")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green)
        .navigationTitle("")
        .navigationBarHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                viewModel.resetField()
            }
        }
    }
}

#Preview {
    NavigationStack {
        SuccessfullySavedView()
            .environmentObject(ExpensesViewModel())
    }
}
