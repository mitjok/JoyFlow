//
//  CalendarView.swift
//  JoyFlow
//
//  Created by god on 02/06/2024.
//

import FirebaseAuth
import SwiftUI
import FirebaseFirestore
import RealmSwift

struct ScheduleView: View {
    @State private var selectedDate = Date()
    @State private var tasks: [Task] = []
    @State private var showingTaskEditor = false
    @State private var editingTask: Task?
    @State private var currentViewMode: ViewMode = .day
    @State private var streamers: [User] = [] // Список стримеров
    @State private var currentUser: User? // Текущий пользователь

    enum ViewMode {
        case day, week, month
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("View Mode", selection: $currentViewMode) {
                    Text("Day").tag(ViewMode.day)
                    Text("Week").tag(ViewMode.week)
                    Text("Month").tag(ViewMode.month)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if currentViewMode == .day {
                    DayView(selectedDate: $selectedDate, tasks: $tasks, showTaskEditor: $showingTaskEditor, editingTask: $editingTask)
                } else if currentViewMode == .week {
                    WeekView(selectedDate: $selectedDate, tasks: $tasks)
                } else {
                    MonthView(selectedDate: $selectedDate, tasks: $tasks)
                }
            }
            .navigationBarTitle("Schedule")
            .navigationBarItems(trailing: Button(action: {
                editingTask = nil
                showingTaskEditor = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingTaskEditor) {
                if let currentUser = currentUser {
                    TaskEditorView(task: $editingTask, saveAction: saveTask, streamers: streamers, currentUser: currentUser)
                } else {
                    Text("Loading...") // Или другое представление для загрузки
                }
            }
            .onAppear {
                loadTasks()
                loadStreamers()
                loadCurrentUser()
            }
        }
    }
    
    private func loadTasks() {
        let db = Firestore.firestore()
        let realm = try! Realm()
        
        // Clear existing tasks in Realm to prevent duplication
        try! realm.write {
            realm.delete(realm.objects(Task.self))
        }
        
        // Load tasks from Firestore and save them to Realm
        db.collection("tasks").getDocuments { snapshot, error in
            if let error = error {
                print("Error loading tasks: \(error)")
                return
            }
            let firestoreTasks = snapshot?.documents.compactMap { document in
                try? document.data(as: Task.self)
            } ?? []
            
            // Save tasks to Realm
            try! realm.write {
                realm.add(firestoreTasks, update: .modified)
            }
            
            // Update local tasks array
            self.tasks = Array(realm.objects(Task.self))
        }
    }
    
    private func loadStreamers() {
        let db = Firestore.firestore()
        
        // Load streamers from Firestore
        db.collection("users").whereField("role", isEqualTo: "streamer").getDocuments { snapshot, error in
            if let error = error {
                print("Error loading streamers: \(error)")
                return
            }
            self.streamers = snapshot?.documents.compactMap { document in
                try? document.data(as: User.self)
            } ?? []
        }
    }
    
    private func loadCurrentUser() {
        if let user = Auth.auth().currentUser {
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error fetching user data: \(error)")
                    return
                }
                guard let document = documentSnapshot, let data = document.data() else { return }
                self.currentUser = try? document.data(as: User.self)
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

        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        } else {
            tasks.append(task)
        }
        showingTaskEditor = false
    }
}
