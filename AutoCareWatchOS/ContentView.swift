////
////  ContentView.swift
////  AutoCareWatchOS
////
////  Created by Ivan Maslennikov on 20.03.2025.
////
//
//import SwiftUI
//
//struct ContentView: View {
//    
//    @StateObject private var viewModel: ExpensesViewModel = ExpensesViewModel()
//
//    var body: some View {
//        NavigationStack(path: $viewModel.navigationPath) {
//            AddExpenseView()
//                .environmentObject(viewModel)
//                .navigationDestination(for: ExpenseStep.self) { step in
//                    switch step {
//                    case .enterTitle:
//                        ExpenseTitleInputView()
//                            .environmentObject(viewModel)
//                    case .enterAmount:
//                        ExpenseAmountInputView()
//                            .environmentObject(viewModel)
//                    case .selectCategory:
//                        ExpenseCategorySelectionView()
//                            .environmentObject(viewModel)
//                    case .confirm:
//                        FinalExpensView()
//                            .environmentObject(viewModel)
//                    case .successfull:
//                        SuccessfullySavedView()
//                            .environmentObject(viewModel)
//                    }
//                }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//        .environmentObject(ExpensesViewModel())
//}
