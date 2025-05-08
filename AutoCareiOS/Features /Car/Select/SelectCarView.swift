//
//  SelectCar.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 29.10.2024.
//

import SwiftUI

struct SelectCarView: View {
    
    @EnvironmentObject var carViewModel: CarViewModel
    
    @State private var showAddCar: Bool = false
    @State private var showEditCar: Bool = false
    @State private var carIndexForDelete: IndexSet? = nil
    
    @State private var editCar: Car?
    
    @State private var сarForRemoval = ""
    @State private var showDeleteConfirmantion: Bool = false
   
    var body: some View {
        
        if carViewModel.allCars.isEmpty {
            
            emptyCarList
            
        } else {
            
            NavigationStack {
                ScrollView {
                    mainScreen
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button(action: {
                                    showAddCar.toggle()
                                }) {
                                    Image(systemName: "plus.circle")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                        .sheet(isPresented: $showAddCar) {
                            AddCarView()
                        }
                        .sheet(item: $editCar) { car in
                            EditCarView(editingForCar: car)}
                    
                    
                    Spacer()
                }
                .onAppear {
                    carViewModel.getAllCars()
                }
                .alert(isPresented: $showDeleteConfirmantion) {
                    Alert(title: Text("Delete car"),
                          message: Text("Are you sure want to delete \(сarForRemoval)"),
                          primaryButton: .destructive(Text("Yes, delete")) {
                        if let indexCar = carIndexForDelete {
                            carViewModel.deleteCar(at: indexCar)
                        }
                    },
                          secondaryButton: .cancel()
                    )
                }
            }
        }
    }
    
    private var mainScreen: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("My Cars")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 10)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            ForEach(carViewModel.allCars, id: \.self) { car in
                HStack {
                    SelectRowCarView(car: car)
                    
                    Spacer()
                    
                    Image(systemName: "list.dash")
                        .font(.title3)
                        .foregroundStyle(.gray)
                        .padding(.trailing, 16)
                        .contextMenu {
                            
                            Button {
                                editCar = car
                                showEditCar.toggle()
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            
                            Button {
                                if let vinNumberIndex = carViewModel.allCars.firstIndex( where: { $0.vinNumber == car.vinNumber }) {
                                    let currencyCar = carViewModel.allCars[vinNumberIndex]
                                    copyToClipboard(text: currencyCar.vinNumber ?? "")
                                    provideHapticFeedbackHeavy()
                                }
                            } label: {
                                Label("Copy VIN-Number", systemImage: "doc.circle.fill")
                            }
                            
                            Button {
                                if let indexCar = carViewModel.allCars.firstIndex(where: { $0.id == car.id }) {
                                    carIndexForDelete = IndexSet(integer: indexCar)
                                    сarForRemoval = car.nameModel ?? "Not found"
                                    showDeleteConfirmantion = true
                                }
                                // FIXME:
                                
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                .padding(.horizontal, 20)
                .onTapGesture {
                    carViewModel.selectedCar = car
                }
            }
        }
    }
    
    private var emptyCarList: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "car.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.secondary)
            
            Text("Add your first car to unlock full functionality.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 25)
            
            Button(action: {
                showAddCar.toggle()
            }) {
                Text("Add Car")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .padding()
                    .frame(height: 55)
                    .frame(maxWidth: 140)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .sheet(isPresented: $showAddCar) {
            AddCarView()
        }
    }
}

#Preview {
    SelectCarView()
        .environmentObject(CarViewModel())
}
