//
//  LoginView.swift
//  JoyFlow
//
//  Created by god on 01/06/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import TikTokOpenAuthSDK
import RealmSwift

struct LoginView: View {
    
    @Binding var isAuthenticated: Bool
    @Binding var currentUser: User?
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    private var db = Firestore.firestore()
    private let realm = try! Realm()

        
    public init(isAuthenticated: Binding<Bool>, currentUser: Binding<User?>) {
        self._isAuthenticated = isAuthenticated
        self._currentUser = currentUser
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("JoyFlow Welcomes")
                    .font(.largeTitle)
                    .padding()
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding(.top, 12)
                
                TextField("Email", text: $email)
                //.keyboardType(.namePhonePad)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                
                if email != "" {
                    Button(action: {
                        authenticateUser()
                    }) {
                        Text("Login")
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                Button(action: {
                    authenticateWithGoogle()
                }) {
                    Text("Login with Google")
                        .font(.title)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    authenticateWithTikTok()
                }) {
                    Text("Login with TikTok")
                        .font(.title)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                
                NavigationLink(destination: RegistrationView(isAuthenticated: $isAuthenticated, currentUser: $currentUser)) {
                    Text("Registration")
                        .padding()
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    // logic for renewing password
                }) {
                    Text("Forgot Password?")
                        .padding()
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
    }
    
    func authenticateUser() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error logging in: \(error)")
                return
            }
            guard let user = authResult?.user else { return }
            
            db.collection("users").document(user.uid).getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error fetching user data: \(error)")
                    return
                }
                guard let document = documentSnapshot, let data = document.data() else { return }
                if let realmUser = try? JSONDecoder().decode(User.self, from: JSONSerialization.data(withJSONObject: data)) {
                    try! realm.write {
                        realm.add(realmUser, update: .modified)
                    }
                    self.currentUser = realmUser
                    self.isAuthenticated = true
                }
            }
        }
    }
    
    func authenticateWithGoogle() {
        // TODO: create google auth
        
    }
    
    func authenticateWithTikTok() {
        // TODO: create tiktok auth
        
        
    }
    
    func fetchFirestoreUser(userId: String) {
        db.collection("users").document(userId).getDocument { documentSnapshot, error in
            if let error = error {
                print("Error fetching user data: \(error)")
                return
            }
            guard let document = documentSnapshot, let data = document.data() else { return }
            if let realmUser = try? JSONDecoder().decode(User.self, from: JSONSerialization.data(withJSONObject: data)) {
                try! realm.write {
                    realm.add(realmUser, update: .modified)
                }
                self.currentUser = realmUser
                self.isAuthenticated = true
            }
        }
    }
    
    func getRootViewController() -> UIViewController {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("Unable to find root view controller")
        }
        return window.rootViewController!
    }
    
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
