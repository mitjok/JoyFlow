//
//  RegistrationView.swift
//  JoyFlow
//
//  Created by god on 14/06/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import RealmSwift

struct RegistrationView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var selectedRole = "streamer"
    @State private var errorMessage = ""
    
    @Binding var isAuthenticated: Bool
    @Binding var currentUser: User?
    
    private var db = Firestore.firestore()
    private let realm = try! Realm()

    
    public init(isAuthenticated: Binding<Bool>, currentUser: Binding<User?>) {
        self._isAuthenticated = isAuthenticated
        self._currentUser = currentUser
    }
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Picker("Role", selection: $selectedRole) {
                Text("Streamer").tag("streamer")
                Text("Manager").tag("manager")
            }.pickerStyle(SegmentedPickerStyle())
                .padding()
            
            Button("Register") {
                registerUser()
            }.padding()
            
            Text(errorMessage).foregroundColor(.red).padding()
        }
    }
    
    func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }
            guard let user = authResult?.user else { return }
            
            let userData: [String: Any] = [
                "id": user.uid,
                "name": name,
                "email": email,
                "role": selectedRole
            ]
            
            db.collection("users").document(user.uid).setData(userData) { error in
                if let error = error {
                    errorMessage = error.localizedDescription
                } else {
                    let realmUser = User()
                    realmUser.id = user.uid
                    realmUser.name = name
                    realmUser.email = email
                    realmUser.role = selectedRole
                    
                    try! realm.write {
                        realm.add(realmUser, update: .modified)
                    }
                    
                    self.currentUser = realmUser
                    self.isAuthenticated = true
                }
            }
        }
    }
}
