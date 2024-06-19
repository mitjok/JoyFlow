//
//  ProfileView.swift
//  JoyFlow
//
//  Created by god on 02/06/2024.
//

import SwiftUI
import FirebaseAuth
import RealmSwift

struct ProfileView: View {
    
    @State private var position: String = "Position"
    @State private var contactInfo: String = "Contact information"
    
    @Binding var isAuthenticated: Bool
    @Binding var currentUser: User?

    private let realm = try! Realm()

    
    var body: some View {
        VStack {
            Text(currentUser?.name ?? "User Name")
                .font(.title)
                .padding()
            
            Text(position)
                .padding()
            
            Text(contactInfo)
                .padding()
            
            Button(action: {
                // change password logic
            }) {
                Text("Change Password")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            Button(action: {
                // notifications logic
            }) {
                Text("Notifications")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            Button(action: {
                logout()
            }) {
                Text("LogOut")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            try! realm.write {
                if let user = currentUser {
                    realm.delete(user)
                }
            }
            currentUser = nil
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
}

