//
//  ExpenseCategorySelectionView.swift
//  AutoCareWatchOS
//
//  Created by Ivan Maslennikov on 11.03.2025.
//

import SwiftUI

struct ExpenseCategorySelectionView: View {
    
    @EnvironmentObject var viewModel: ExpensesViewModel
    
    @State private var selectedCategory: RepairCategoryForWatchOS = .service
    
    var body: some View {

            TabView(selection: $selectedCategory) {
                
                ForEach(RepairCategoryForWatchOS.allCases, id: \.self) { category in
                    VStack {
                        Image(category.imageIcon)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 130, height: 130, alignment: .center)
                            .foregroundStyle(Color.white)
                        
                        Text(category.rawValue)
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                    }
                    .onTapGesture {
                        viewModel.category = selectedCategory
//                        WKInterfaceDevice.current().play(.success)
                        viewModel.navigationPath.append(ExpenseStep.confirm)
                    }
                }
            }
            .tabViewStyle(.carousel)
            .onChange(of: selectedCategory) { newValue, _ in
                WKInterfaceDevice.current().play(.click)
            }
    }
}

#Preview {
    NavigationStack {
        ExpenseCategorySelectionView()
            .environmentObject(ExpensesViewModel())
    }
}
