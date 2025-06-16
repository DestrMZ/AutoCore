//
//  SelectDateView.swift
//  carRepairApp
//
//  Created by Ivan Maslennikov on 06.12.2024.
//

import SwiftUI
import DatePickerRange

struct SelectDateView: View {
    
    @StateObject var calendarManager = CalendarManager(minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), isFutureSelectionEnabled: false)
    @Environment(\.dismiss) var dismiss
    
    
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    
    var onDateSelected: ((Date?, Date?) -> ())?

    var body: some View {
        NavigationStack {
            Group {
                
                DPViewController(calendarManager: calendarManager)
                    .onChange(of: calendarManager.startDate) { newStartDate in
                        startDate = newStartDate
                    }
                    .onChange(of: calendarManager.endDate) { newEndDate in
                        endDate = newEndDate
                    }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onDateSelected?(startDate, endDate)
                        dismiss()
                    }
                    .bold()
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .bold()
                }
            }
        }
    }
}

//#Preview {
//    @State var startDate: Date? = Date()
//    @State var endDate: Date? = Date()
//    
//    SelectDateView(startDate: $startDate, endDate: $endDate)
//}
