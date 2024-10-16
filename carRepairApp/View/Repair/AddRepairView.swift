    //
    //  AddRepair.swift
    //  carRepairApp
    //
    //  Created by Ivan Maslennikov on 13.10.2024.
    //

    import SwiftUI
    import PhotosUI
    import Combine

    struct AddRepairView: View {
        
        @EnvironmentObject var repairViewModel: RepairViewModel
        @EnvironmentObject var carViewModel: CarViewModel
        
        @State var selectedImageRepair: PhotosPickerItem?
        @State var repairImage: UIImage?
        @State var showSuccessMessage: Bool = false
        
        var colorCitron: Color = Color("Citron")
        
        var body: some View {
            
            NavigationStack {
                
                VStack {
                    
                    Form {
                        TextField("Name repair", text: $repairViewModel.partReplaced)
                            .disableAutocorrection(true)
                        TextField("Amount", value: $repairViewModel.cost, formatter: numberFormatterForCoast())
                        TextField("Mileage", value: $repairViewModel.repairMileage, formatter: numberFormatterForMileage())
                        TextField("Notes", text: $repairViewModel.notes)
                        
                        DatePicker("Date of repair", selection: $repairViewModel.repairDate)
                        
                        HStack {
                            Text("Add photo")
                            Spacer()
                            PhotosPicker(selection: $selectedImageRepair, matching: .images) {
                                Image(systemName: "photo.badge.plus")
                                    .font(.largeTitle)
                                    .foregroundStyle(.dimGray)
                            }
                        }
                        .onChange(of: selectedImageRepair) { _, newItem in
                            if let newItem = newItem {
                                newItem.loadTransferable(type: Data.self) { result in
                                    switch result {
                                    case .success(let imageData):
                                        if let imageData = imageData {
                                            DispatchQueue.main.async {
                                                self.repairImage = UIImage(data: imageData)
                                                self.repairViewModel.photoRepair = imageData
                                            }
                                            self.showSuccessMessage = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                self.showSuccessMessage = false
                                            }
                                            print("Photo repair successfully uploaded")
                                        }
                                    case .failure(let error):
                                        print("Error uploading photo repair: \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        repairViewModel.createNewRepair()
                        print("Repair created successfully")
                        print("Name: \(repairViewModel.partReplaced)")
                        print("Cost: \(repairViewModel.cost)")
                        print("Notes: \(repairViewModel.notes)")
                        
                    }) {
                        Text("Save repair")
                            .font(Font.system(size: 20))
                            .frame(width: 120, height: 40)
                            .foregroundColor(.black)
                            .padding()
                            .background(.blue)
                            .cornerRadius(30)
                    }
                    .disabled(repairViewModel.partReplaced.isEmpty || repairViewModel.cost <= 0) // Валидация
                }
                .overlay(
                    Group {
                        if showSuccessMessage {
                            Text("Photo successfully uploaded!")
                                .foregroundColor(.green)
                                .transition(.opacity)
                                .animation(.easeInOut, value: showSuccessMessage)
                        }
                    }
                )
            }
        }
    }

    #Preview {
        AddRepairView()
            .environmentObject(CarViewModel())
            .environmentObject(RepairViewModel())
    }
