//
//  ContentView.swift
//  JoyFlow
//
//  Created by user on 31/05/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import RealmSwift

struct ContentView: View {
    
    @State private var isAuthenticated = false
    @State private var currentUser: User?
    
    var body: some View {
        Group {
            if isAuthenticated {
                if let user = currentUser {
                    if user.role == "streamer" {
                        MainStreamerView(isAuthenticated: $isAuthenticated, currentUser: $currentUser)
                    } else if user.role == "manager" {
                        MainManagerView(isAuthenticated: $isAuthenticated, currentUser: $currentUser)
                    }
                } else {
                    Text("Loading user data...")
                }
            } else {
                LoginView(isAuthenticated: $isAuthenticated, currentUser: $currentUser)
            }
        }
        .onAppear {
            checkAuthentication()
        }
    }
    
    func checkAuthentication() {
        if let user = Auth.auth().currentUser {
            let realm = try! Realm()
            if let realmUser = realm.object(ofType: User.self, forPrimaryKey: user.uid) {
                self.currentUser = realmUser
                self.isAuthenticated = true
            } else {
                Firestore.firestore().collection("users").document(user.uid).getDocument { documentSnapshot, error in
                    if let error = error {
                        print("Error fetching user data: \(error)")
                        return
                    }
                    guard let document = documentSnapshot, let data = document.data() else { return }
                    if let fetchedUser = try? JSONDecoder().decode(User.self, from: JSONSerialization.data(withJSONObject: data)) {
                        try! realm.write {
                            realm.add(fetchedUser, update: .modified)
                        }
                        self.currentUser = fetchedUser
                        self.isAuthenticated = true
                    }
                }
            }
        }
    }
}

