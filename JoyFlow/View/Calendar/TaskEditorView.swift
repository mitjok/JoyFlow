//
//  TaksEditorView.swift
//  JoyFlow
//
//  Created by god on 17/06/2024.
//

import SwiftUI

struct TaskEditorView: View {
    @Binding var task: Task?
    var saveAction: (Task) -> Void
    var streamers: [User] // Список стримеров
    var currentUser: User? // Текущий пользователь (менеджер или стример)

    @State private var title: String = ""
    @State private var details: String = ""
    @State private var date = Date()
    @State private var selectedStreamerId: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextField("Details", text: $details)
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    
                    if currentUser?.role == "manager" {
                        Picker("Streamer", selection: $selectedStreamerId) {
                            ForEach(streamers) { streamer in
                                Text(streamer.name).tag(streamer.id)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(task == nil ? "New Task" : "Edit Task", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                task = nil
            }, trailing: Button("Save") {
                guard let currentUser = currentUser else {
                    print("Error: Current user is nil")
                    return
                }
                let newTask = Task(
                    id: task?.id ?? UUID().uuidString,
                    title: title,
                    details: details,
                    date: date,
                    streamerId: currentUser.role == "manager" ? selectedStreamerId : currentUser.id,
                    managerId: currentUser.role == "manager" ? currentUser.id : ""
                )
                saveAction(newTask)
                task = nil
            })
        }
        .onAppear {
            if let task = task {
                title = task.title
                details = task.details
                date = task.date
                selectedStreamerId = task.streamerId
            }
        }
    }
}


