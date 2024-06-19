//
//  DayView.swift
//  JoyFlow
//
//  Created by god on 18/06/2024.
//

import SwiftUI
import FirebaseFirestore
import RealmSwift

struct DayView: View {
    @Binding var selectedDate: Date
    @Binding var tasks: [Task]
    @Binding var showTaskEditor: Bool
    @Binding var editingTask: Task?

    let db = Firestore.firestore()
    let realm = try! Realm()

    var body: some View {
        VStack {
            List {
                ForEach(tasksForSelectedDate()) { task in
                    HStack {
                        NavigationLink(destination: TaskDetailView(taskId: task.id)) {
                            VStack(alignment: .leading) {
                                Text(task.date, style: .time)
                                Text(task.title)
                                    .font(.headline)
                                Text(task.details)
                                    .font(.subheadline)
                            }
                        }
                        Spacer()
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(action: {
                            editingTask = task
                            showTaskEditor = true
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                        
                        Button(role: .destructive, action: {
                            deleteTask(task)
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationBarTitle("Day View for \(formattedDate(selectedDate))", displayMode: .inline)
        }
        .onAppear {
            loadTasks()
        }
    }
    
    private func tasksForSelectedDate() -> [Task] {
        return tasks.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    private func loadTasks() {
        self.tasks = Array(realm.objects(Task.self))
    }
    
    private func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        
        // Delete task from Firestore
        db.collection("tasks").document(task.id).delete { error in
            if let error = error {
                print("Error deleting task from Firestore: \(error)")
            }
        }

        // Delete task from Realm
        do {
            try realm.write {
                if let realmTask = realm.object(ofType: Task.self, forPrimaryKey: task.id) {
                    realm.delete(realmTask)
                }
            }
        } catch {
            print("Error deleting task from Realm: \(error)")
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

