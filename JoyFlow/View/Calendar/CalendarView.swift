//
//  CalendarView.swift
//  JoyFlow
//
//  Created by god on 17/06/2024.
//

import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    @Binding var tasks: [Task]
    var onDaySelected: (Date) -> Void

    var body: some View {
        let month = Calendar.current.dateInterval(of: .month, for: selectedDate)!
        let days = Calendar.current.range(of: .day, in: .month, for: selectedDate)!
        let firstWeekday = Calendar.current.component(.weekday, from: month.start)
        let offset = (firstWeekday - Calendar.current.firstWeekday + 7) % 7

        VStack {
            HStack {
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate)!
                }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(formattedMonth(selectedDate))
                    .font(.headline)
                Spacer()
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate)!
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(0..<days.count + offset, id: \.self) { index in
                    if index >= offset {
                        let day = index - offset + 1
                        let date = Calendar.current.date(byAdding: .day, value: day - 1, to: month.start)!
                        Text("\(day)")
                            .padding()
                            .background(Calendar.current.isDate(selectedDate, inSameDayAs: date) ? Color.blue : Color.clear)
                            .clipShape(Circle())
                            .onTapGesture {
                                selectedDate = date
                                onDaySelected(date)
                            }
                            .overlay(
                                tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }.isEmpty ? nil :
                                    Circle().stroke(Color.red, lineWidth: 2)
                            )
                    } else {
                        Text("")
                    }
                }
            }
            .padding()
        }
    }
    
    private func formattedMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}
