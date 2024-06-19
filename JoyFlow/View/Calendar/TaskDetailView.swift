//
//  TaskDetailView.swift
//  JoyFlow
//
//  Created by god on 18/06/2024.
//

import SwiftUI
import RealmSwift
import FirebaseFirestore

struct TaskDetailView: View {
    var taskId: String
    @Environment(\.presentationMode) var presentationMode
    @State private var task: Task?
    @State private var showTaskEditor = false

    let realm = try! Realm()
    let db = Firestore.firestore()

    var body: some View {
        VStack(alignment: .leading) {
            if let task = task {
                Text(task.title)
                    .font(.largeTitle)
                    .padding(.bottom, 10)
                Text("Details:")
                    .font(.headline)
                Text(task.details)
                    .padding(.bottom, 10)
                Text("Date:")
                    .font(.headline)
                Text(task.date, style: .date)
                Text(task.date, style: .time)
                    .padding(.bottom, 10)
                if !task.streamerId.isEmpty {
                    Text("Streamer ID:")
                        .font(.headline)
                    Text(task.streamerId)
                        .padding(.bottom, 10)
                }
                if !task.managerId.isEmpty {
                    Text("Manager ID:")
                        .font(.headline)
                    Text(task.managerId)
                        .padding(.bottom, 10)
                }
                
                HStack {
                    Button(action: {
                        showTaskEditor = true
                    }) {
                        Text("Edit")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Button(action: {
                        deleteTask()
                    }) {
                        Text("Delete")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.top, 20)
            } else {
                Text("Loading...")
                    .font(.headline)
            }
        }
        .padding()
        .navigationBarTitle("Task Details", displayMode: .inline)
        .onAppear {
            loadTask()
        }
        .sheet(isPresented: $showTaskEditor) {
            if let task = task {
                TaskEditorView(task: .constant(task), saveAction: saveTask, streamers: [], currentUser: nil) // Update streamers and currentUser as needed
            }
        }
    }
    
    private func loadTask() {
        task = realm.object(ofType: Task.self, forPrimaryKey: taskId)
    }
    
    private func deleteTask() {
        if let task = task {
            // Delete task from Firestore
            db.collection("tasks").document(task.id).delete { error in
                if let error = error {
                    print("Error deleting task from Firestore: \(error)")
                }
            }

            // Delete task from Realm
            do {
                try realm.write {
                    realm.delete(task)
                }
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("Error deleting task from Realm: \(error)")
            }
        }
    }

    private func saveTask(task: Task) {
        let db = Firestore.firestore()
        let realm = try! Realm()
        
        // Save task to Firestore
        do {
            try db.collection("tasks").document(task.id).setData(from: task)
        } catch {
            print("Error saving task to Firestore: \(error)")
        }

        // Save task to Realm
        do {
            try realm.write {
                realm.add(task, update: .modified)
            }
        } catch {
            print("Error saving task to Realm: \(error)")
        }
    }
}
