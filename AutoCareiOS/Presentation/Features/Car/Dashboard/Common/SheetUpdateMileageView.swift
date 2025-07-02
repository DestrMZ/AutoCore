//
//  SheetUpdateMileageView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 03.06.2025.
//

import SwiftUI

struct SheetUpdateMileageView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var carViewModel: CarViewModel
    
    @State var newMileage: String = ""
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    
    var body: some View {
            NavigationStack {
                VStack(spacing: 10) {
                    
                    TextField(NSLocalizedString("Enter new mileage", comment: ""), text: $newMileage)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)

                    Button(action: {
                        if let car = carViewModel.selectedCar {
                            guard let mileageInt = Int32(newMileage) else {
                                alertTitle = NSLocalizedString("Invalid mileage format", comment: "")
                                showAlert = true
                                return
                            }
                            
                            let result = carViewModel.updateMileage(for: car, mileage: mileageInt)
                            
                            if result.success {
                                dismiss()
                            } else {
                                alertTitle = result.message
                                showAlert = true
                            }
                        }
                    }) {
                        Label(NSLocalizedString("Update Mileage", comment: ""), systemImage: "checkmark.circle.fill")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                    }
                    .background(.primary)
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(10)
                    .disabled(newMileage == "")
                    .padding()
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(NSLocalizedString("😳 Ops...", comment: "")), message: Text("\(alertTitle)"))
                }
            }
        }
}

#Preview {
    let car = Car(context: CoreDataStack.shared.context)
    car.mileage = 125000
    let carViewModel = CarViewModel()
    carViewModel.selectedCar = car
    
    return SheetUpdateMileageView()
        .environmentObject(carViewModel)
}
