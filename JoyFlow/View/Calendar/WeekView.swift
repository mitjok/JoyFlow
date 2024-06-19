//
//  WeekView.swift
//  JoyFlow
//
//  Created by god on 18/06/2024.
//

import SwiftUI
import FirebaseFirestore
import RealmSwift

struct WeekView: View {
    @Binding var selectedDate: Date
    @Binding var tasks: [Task]

    var body: some View {
        VStack {
            ForEach(weekDates(for: selectedDate), id: \.self) { date in
                VStack(alignment: .leading) {
                    Text(formattedDate(date))
                        .font(.headline)
                    ForEach(tasksForDate(date)) { task in
                        HStack {
                            Text(task.date, style: .time)
                            VStack(alignment: .leading) {
                                Text(task.title)
                                    .font(.headline)
                                Text(task.details)
                                    .font(.subheadline)
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationBarTitle("Week View for \(formattedWeek(selectedDate))", displayMode: .inline)
    }
    
    private func tasksForDate(_ date: Date) -> [Task] {
        return tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    private func weekDates(for date: Date) -> [Date] {
        var dates = [Date]()
        guard let weekInterval = Calendar.current.dateInterval(of: .weekOfMonth, for: date) else { return dates }
        var currentDate = weekInterval.start
        while currentDate <= weekInterval.end {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func formattedWeek(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let startOfWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: date)!.start
        let endOfWeek = Calendar.current.dateInterval(of: .weekOfMonth, for: date)!.end
        return "\(formatter.string(from: startOfWeek)) - \(formatter.string(from: endOfWeek))"
    }
}

