//
//  CreateChatView.swift
//  JoyFlow
//
//  Created by god on 14/06/2024.
//

import SwiftUI
import FirebaseFirestore


struct CreateChatView: View {
    @Binding var isCreatingChat: Bool
    @Binding var currentUser: User?
    @Binding var selectedChat: Chat?
    @Binding var navigateToChatDetail: Bool
    @State private var query = ""
    @State private var users = [User]()
    @State private var selectedUsers = Set<User>()
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            TextField("Search users", text: $query)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: query) { newQuery in
                    searchUsers(query: newQuery)
                }
            
            List {
                ForEach(users, id: \.id) { user in
                    HStack {
                        Text(user.name)
                        Spacer()
                        if selectedUsers.contains(user) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleSelection(for: user)
                    }
                }
            }

            Button("Create Chat") {
                if selectedUsers.count == 1 {
                    createOrNavigateToOneOnOneChat()
                } else {
                    createGroupChat()
                }
            }
            .disabled(selectedUsers.isEmpty)
            .padding()
        }
        .navigationTitle("Create Chat")
    }

    private func toggleSelection(for user: User) {
        if selectedUsers.contains(user) {
            selectedUsers.remove(user)
        } else {
            selectedUsers.insert(user)
        }
    }
    
    private func searchUsers(query: String) {
        //let lowercasedQuery = query.lowercased()
        Firestore.firestore().collection("users")
            .whereField("name", isGreaterThanOrEqualTo: query)
            .whereField("name", isLessThanOrEqualTo: query + "\u{f8ff}")
        //.order(by: "nameLowercase")
        //.start(at: [lowercasedQuery])
        //.end(at: [lowercasedQuery + "\u{f8ff}"])
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error searching users: \(error)")
                    return
                }
                self.users = snapshot?.documents.compactMap { document in
                    let user = try? document.data(as: User.self)
                    return user?.id != currentUser?.id ? user : nil
                } ?? []
            }
    }
    
    private func createOrNavigateToOneOnOneChat() {
        let selectedUser = selectedUsers.first!
        let chatID = Chat.oneOnOneChatID(for: [currentUser!.id, selectedUser.id])
        
        Firestore.firestore().collection("chats")
            .whereField("id", isEqualTo: chatID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching chat: \(error.localizedDescription)")
                    return
                }
                
                if let document = snapshot?.documents.first {
                    if let chat = try? document.data(as: Chat.self) {
                        navigateToChat(chat)
                    }
                } else {
                    selectedUsers.insert(currentUser!)
                    viewModel.createChat(with: Array(selectedUsers)) { chat in
                        navigateToChat(chat)
                    }
                }
            }
    }
    
    private func createGroupChat() {
        selectedUsers.insert(currentUser!)
        viewModel.createChat(with: Array(selectedUsers)) { chat in
            navigateToChat(chat)
        }
        self.isCreatingChat = false
    }
    
    private func navigateToChat(_ chat: Chat) {
        self.selectedChat = chat
        self.navigateToChatDetail = true
        self.isCreatingChat = false
    }
}


/*
struct CreateChatView: View {
    @Binding var isCreatingChat: Bool
    @Binding var currentUser: User?
    @State private var query = ""
    @State private var users = [User]()
    @State private var selectedUsers = Set<User>()
    @StateObject private var viewModel = ChatViewModel()
    @State private var selectedChat: Chat? = nil
    @State private var navigateToChatDetail = false

    var body: some View {
        VStack {
            TextField("Search users", text: $query)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: query) { newQuery in
                    searchUsers(query: newQuery)
                }
            
            List {
                ForEach(users, id: \.id) { user in
                    HStack {
                        Text(user.name)
                        Spacer()
                        if selectedUsers.contains(user) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleSelection(for: user)
                    }
                }
            }

            Button("Create Chat") {
                if selectedUsers.count == 1 {
                    createOrNavigateToOneOnOneChat()
                } else {
                    createGroupChat()
                }
            }
            .disabled(selectedUsers.isEmpty)
            .padding()
        }
        .navigationTitle("Create Chat")
        .background(
            NavigationLink(destination: ChatDetailView(chat: selectedChat ?? Chat(), currentUser: $currentUser), isActive: $navigateToChatDetail) {
                EmptyView()
            }
        )
    }

    private func toggleSelection(for user: User) {
        if selectedUsers.contains(user) {
            selectedUsers.remove(user)
        } else {
            selectedUsers.insert(user)
        }
    }
    
    private func searchUsers(query: String) {
        Firestore.firestore().collection("users")
            .whereField("name", isGreaterThanOrEqualTo: query)
            .whereField("name", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error searching users: \(error)")
                    return
                }
                self.users = snapshot?.documents.compactMap { document in
                    let user = try? document.data(as: User.self)
                    return user?.id != currentUser?.id ? user : nil
                } ?? []
            }
    }
    
    private func createOrNavigateToOneOnOneChat() {
        let selectedUser = selectedUsers.first!
        let chatID = Chat.oneOnOneChatID(for: [currentUser!.id, selectedUser.id])
        
        Firestore.firestore().collection("chats")
            .whereField("id", isEqualTo: chatID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching chat: \(error.localizedDescription)")
                    return
                }
                
                if let document = snapshot?.documents.first {
                    if let chat = try? document.data(as: Chat.self) {
                        // navigate to existing chat
                        navigateToChat(chat)
                    }
                } else {
                    // create a new chat
                    selectedUsers.insert(currentUser!)
                    viewModel.createChat(with: Array(selectedUsers)) { chat in
                        navigateToChat(chat)
                    }
                }
            }
    }
    
    private func createGroupChat() {
        selectedUsers.insert(currentUser!)
        viewModel.createChat(with: Array(selectedUsers)) { chat in
            navigateToChat(chat)
        }
        self.isCreatingChat = false
    }
    
    private func navigateToChat(_ chat: Chat) {
        self.selectedChat = chat
        self.navigateToChatDetail = true
        self.isCreatingChat = false
    }
}
*/

/*
struct CreateChatView: View {
    @Binding var isCreatingChat: Bool
    @Binding var currentUser: User?
    @State private var query = ""
    @State private var users = [User]()
    @State private var selectedUsers = Set<User>()
    @StateObject private var viewModel = ChatViewModel()
    @State private var selectedChat: Chat?
    @State private var navigateToChatDetail = false

    
    var body: some View {
        VStack {
            TextField("Search users", text: $query)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: query) { newQuery in
                    searchUsers(query: newQuery)
                }
            
            List {
                ForEach(users, id: \.id) { user in
                    HStack {
                        Text(user.name)
                        Spacer()
                        if selectedUsers.contains(user) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleSelection(for: user)
                    }
                }
            }

            Button("Create Chat") {
                if selectedUsers.count == 1 {
                    createOrNavigateToOneOnOneChat()
                } else {
                    createGroupChat()
                }
            }
            .disabled(selectedUsers.isEmpty)
            .padding()
        }
        .navigationTitle("Create Chat")
        .background(
            NavigationLink(destination: ChatDetailView(chat: selectedChat ?? Chat(), currentUser: $currentUser), isActive: $navigateToChatDetail) {
                EmptyView()
            }
        )
    }

    private func toggleSelection(for user: User) {
        if selectedUsers.contains(user) {
            selectedUsers.remove(user)
        } else {
            selectedUsers.insert(user)
        }
    }
    
    private func searchUsers(query: String) {
        Firestore.firestore().collection("users")
            .whereField("name", isGreaterThanOrEqualTo: query)
            .whereField("name", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error searching users: \(error)")
                    return
                }
                self.users = snapshot?.documents.compactMap { document in
                    let user = try? document.data(as: User.self)
                    return user?.id != currentUser?.id ? user : nil
                } ?? []
            }
    }
    
    private func createOrNavigateToOneOnOneChat() {
        let selectedUser = selectedUsers.first!
        let chatID = Chat.oneOnOneChatID(for: [currentUser!.id, selectedUser.id])
        
        Firestore.firestore().collection("chats")
            .whereField("id", isEqualTo: chatID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching chat: \(error.localizedDescription)")
                    return
                }
                
                if let document = snapshot?.documents.first {
                    if let chat = try? document.data(as: Chat.self) {
                        // Navigate to the existing chat
                        navigateToChat(chat)
                    }
                } else {
                    // Create a new chat
                    selectedUsers.insert(currentUser!)
                    viewModel.createChat(with: selectedUsers.map({ $0.id }))
                    self.isCreatingChat = false
                }
            }
    }
    
    private func createGroupChat() {
        selectedUsers.insert(currentUser!)
        viewModel.createChat(with: selectedUsers.map({ $0.id }))
        self.isCreatingChat = false
    }
    
    private func navigateToChat(_ chat: Chat) {
        self.isCreatingChat = false
        self.selectedChat = chat
        self.navigateToChatDetail = true
    }
}*/


/*

struct CreateChatView: View {
    @Binding var isCreatingChat: Bool
    @Binding var currentUser: User?
    @State private var query = ""
    @State private var users = [User]()
    @State private var selectedUsers = Set<User>()
    @StateObject private var viewModel = ChatViewModel()
    @State private var selectedChat: Chat?

    
    var body: some View {
        VStack {
            TextField("Search users", text: $query)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: query) { newQuery in
                    searchUsers(query: newQuery)
                }
            
            List {
                ForEach(users, id: \.id) { user in
                    HStack {
                        Text(user.name)
                        Spacer()
                        if selectedUsers.contains(user) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleSelection(for: user)
                    }
                }
            }

            Button("Create Chat") {
                if selectedUsers.count == 1 {
                    createOrNavigateToOneOnOneChat()
                } else {
                    createGroupChat()
                }
            }
            .disabled(selectedUsers.isEmpty)
            .padding()
        }
        .navigationTitle("Create Chat")
    }

    private func toggleSelection(for user: User) {
        if selectedUsers.contains(user) {
            selectedUsers.remove(user)
        } else {
            selectedUsers.insert(user)
        }
    }
    
    private func searchUsers(query: String) {
        Firestore.firestore().collection("users")
            .whereField("name", isGreaterThanOrEqualTo: query)
            .whereField("name", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error searching users: \(error)")
                    return
                }
                self.users = snapshot?.documents.compactMap { document in
                    let user = try? document.data(as: User.self)
                    return user?.id != currentUser?.id ? user : nil
                } ?? []
            }
    }
    
    private func createOrNavigateToOneOnOneChat() {
        let selectedUser = selectedUsers.first!
        let chatID = Chat.oneOnOneChatID(for: [currentUser!.id, selectedUser.id])
        
        Firestore.firestore().collection("chats")
            .whereField("id", isEqualTo: chatID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching chat: \(error.localizedDescription)")
                    return
                }
                
                if let document = snapshot?.documents.first {
                    if let chat = try? document.data(as: Chat.self) {
                        // Navigate to the existing chat
                        navigateToChat(chat)
                    }
                } else {
                    // Create a new chat
                    selectedUsers.insert(currentUser!)
                    viewModel.createChat(with: selectedUsers.map({ $0.id }))
                    self.isCreatingChat = false
                }
            }
    }
    
    private func createGroupChat() {
        selectedUsers.insert(currentUser!)
        viewModel.createChat(with: selectedUsers.map({ $0.id }))
        self.isCreatingChat = false
    }
    
    private func navigateToChat(_ chat: Chat) {
        self.isCreatingChat = false
        self.selectedChat = chat
    }
}*/


/*
 struct CreateChatView: View {
    @Binding var isCreatingChat: Bool
    @State private var query = ""
    @State private var users = [User]()
    @State private var selectedUsers = Set<User>()
    @StateObject private var viewModel = ChatViewModel()
    @Binding var currentUser: User?
    @State private var selectedChat: Chat? = nil

    var body: some View {
        VStack {
            TextField("Search users", text: $query)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: query) { newQuery in
                    searchUsers(query: newQuery)
                }
            
            //            List(users, id: \.id, selection: $selectedUsers) { user in
            //                Text(user.name)
            //            }
            List {
                ForEach(users, id: \.id) { user in
                    HStack {
                        Text(user.name)
                        Spacer()
                        if selectedUsers.contains(user) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleSelection(for: user)
                    }
                }
            }
            

            Button("Create Chat") {
                if selectedUsers.count == 1 {
                    createOrNavigateToOneOnOneChat()
                } else {
                    createGroupChat()
                }
                
                //selectedUsers.insert(currentUser!)
                //viewModel.createChat(with: selectedUsers.map({$0.id} ), chatId: UUID().uuidString)
                //self.isCreatingChat = false
            }
            .disabled(selectedUsers.isEmpty)
            .padding()
        }
        .navigationTitle("Create Chat")
    }

    private func toggleSelection(for user: User) {
            if selectedUsers.contains(user) {
                selectedUsers.remove(user)
            } else {
                selectedUsers.insert(user)
            }
        }
    
    private func searchUsers(query: String) {
            //guard let currentUserId = Auth.auth().currentUser?.uid else { return }

            Firestore.firestore().collection("users")
                .whereField("name", isGreaterThanOrEqualTo: query)
                .whereField("name", isLessThanOrEqualTo: query + "\u{f8ff}")
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error searching users: \(error)")
                        return
                    }
                    self.users = snapshot?.documents.compactMap { document in
                        let user = try? document.data(as: User.self)
                        return user?.id != currentUser?.id ? user : nil
                    } ?? []
                }
        }
    
    private func createOrNavigateToOneOnOneChat() {
            let selectedUser = selectedUsers.first!
        let chatID = Chat.oneOnOneChatID(for: [currentUser!.id, selectedUser.id])
            
            Firestore.firestore().collection("chats")
                .whereField("id", isEqualTo: chatID)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching chat: \(error.localizedDescription)")
                        return
                    }
                    
                    if let document = snapshot?.documents.first {
                        if let chat = try? document.data(as: Chat.self) {
                            // Navigate to the existing chat
                            navigateToChat(chat)
                        }
                    } else {
                        // Create a new chat
                        selectedUsers.insert(currentUser!)
                        viewModel.createChat(with: selectedUsers.map({$0.id} ))
                        self.isCreatingChat = false
                    }
                }
        }
        
        private func createGroupChat() {
            selectedUsers.insert(currentUser!)
            viewModel.createChat(with: selectedUsers.map({$0.id} ))
            self.isCreatingChat = false
        }
    
        private func navigateToChat(_ chat: Chat) {
            selectedChat = chat
        }
    
    
//
//    func searchUsers(query: String) {
//        // search users in Firestore by name or email
//        Firestore.firestore().collection("users")
//            .whereField("name", isGreaterThanOrEqualTo: query)
//            .whereField("name", isLessThanOrEqualTo: query + "\u{f8ff}")
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    print("Error searching users: \(error)")
//                    return
//                }
//                self.users = snapshot?.documents.compactMap { document in
//                    try? document.data(as: User.self)
//                } ?? []
//            }
//    }

//    func createChat() {
//        let chatID = UUID().uuidString
//        let chatData: [String: Any] = [
//            "id": chatID,
//            "members": selectedUsers.map { $0.id },
//            "createdAt": Timestamp(date: Date())
//        ]
//
//        Firestore.firestore().collection("chats").document(chatID).setData(chatData) { error in
//            if let error = error {
//                print("Error creating chat: \(error)")
//                return
//            }
//            self.isCreatingChat = false
//        }
//    }
}
*/
