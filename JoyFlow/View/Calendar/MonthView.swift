//
//  MonthView.swift
//  JoyFlow
//
//  Created by god on 18/06/2024.
//

import SwiftUI
import FirebaseFirestore
import RealmSwift

struct MonthView: View {
    @Binding var selectedDate: Date
    @Binding var tasks: [Task]
    @State private var showDayView = false

    var body: some View {
        VStack {
            CalendarView(selectedDate: $selectedDate, tasks: $tasks, onDaySelected: { date in
                selectedDate = date
                showDayView = true
            })
            List {
                ForEach(tasksForSelectedDate()) { task in
                    VStack(alignment: .leading) {
                        Text(task.date, style: .date)
                        Text(task.title)
                            .font(.headline)
                    }
                }
            }
        }
        .navigationBarTitle("Month View for \(formattedMonth(selectedDate))", displayMode: .inline)
        .sheet(isPresented: $showDayView) {
            DayView(selectedDate: $selectedDate, tasks: $tasks, showTaskEditor: .constant(false), editingTask: .constant(nil))
        }
    }
    
    private func tasksForSelectedDate() -> [Task] {
        return tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    private func formattedMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

