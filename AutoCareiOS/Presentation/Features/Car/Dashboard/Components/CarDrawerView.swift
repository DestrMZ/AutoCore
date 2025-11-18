//
//  CarDrawerView.swift
//  AutoCareiOS
//
//  Created by Ivan Maslennikov on 26.05.2025.
//

import SwiftUI

struct CarDrawerView: View {
    @EnvironmentObject var carViewModel: CarViewModel
    @Binding var isDrawerOpen: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            if isDrawerOpen {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isDrawerOpen = false
                        }
                    }

                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Your cars")
                            .font(.headline)
                            .padding(.horizontal, 10)
                        Spacer()
                        Button(action: {
                            withAnimation {
                                isDrawerOpen = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .padding()
                        }
                    }

                    Divider()
                   
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(carViewModel.cars, id: \.id) { car in
                                SelectRowCarView(car: car)
                                    .padding()
                                    .onTapGesture {
                                        carViewModel.selectedCar = car
                                        withAnimation {
                                            isDrawerOpen = false
                                        }
                                    }
                                    .contextMenu {
                                        Button {
                                            
                                        } label: {
                                            Label("Trash", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                    }
                }
                .frame(width: 300)
                .background(Color(.systemBackground))
                .transition(.move(edge: .leading))
                .zIndex(1)
            }
        }
    }
    
    private func deleteItem(ofsett: IndexSet) {
        
    }
}


//#Preview {
//    let car1 = Car(context: CoreDataStack.shared.context)
//    let car2 = Car(context: CoreDataStack.shared.context)
//    let car3 = Car(context: CoreDataStack.shared.context)
//    
//    let carViewModel = CarViewModel()
//    
//    car1.nameModel = "Mazda 6"
//    car1.vinNumber = "VIN123"
//
//    car2.nameModel = "Opel"
//    car2.vinNumber = "VIN1234" 
//    
//    car3.nameModel = "Hyundai Elantra"
//    car3.vinNumber = "VIN12345"
//    
//    carViewModel.allCars = [car1, car2, car3]
//    
//    
//    return CarDrawerView(isDrawerOpen: .constant(true))
//        .environmentObject(carViewModel)
//}
