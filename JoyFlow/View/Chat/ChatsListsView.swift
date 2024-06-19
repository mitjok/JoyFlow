//
//  ChatListsView.swift
//  JoyFlow
//
//  Created by god on 14/06/2024.
//

import SwiftUI
import FirebaseFirestore
import RealmSwift

struct ChatsListView: View {
    @StateObject private var viewModel = ChatViewModel()
    @Binding var currentUser: User?
    @State private var isCreatingChat = false
    @State private var selectedChat: Chat?
    @State private var navigateToChatDetail = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.chats) { chat in
                        NavigationLink(destination: ChatDetailView(chat: chat, currentUser: $currentUser)) {
                            VStack(alignment: .leading) {
                                Text(getChatName(chat))
                                Text(chat.lastMessage)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .navigationTitle("Chats")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isCreatingChat = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $isCreatingChat) {
                    CreateChatView(
                        isCreatingChat: $isCreatingChat,
                        currentUser: $currentUser,
                        selectedChat: $selectedChat,
                        navigateToChatDetail: $navigateToChatDetail
                    )
                }
                .background(
                    NavigationLink(destination: ChatDetailView(chat: selectedChat ?? Chat(), currentUser: $currentUser), isActive: $navigateToChatDetail) {
                        EmptyView()
                    }
                )
                .onAppear {
                    if let user = currentUser {
                        viewModel.fetchChats(for: user.id)
                    }
                }
            }
        }
    }
    
    private func getChatName(_ chat: Chat) -> String {
        if chat.name.isEmpty {
            let otherParticipants = chat.participants.filter { $0 != currentUser?.id }
            return otherParticipants.joined(separator: ", ")
        } else {
            return chat.name
        }
    }
}

/*
struct ChatsListView: View {
    @StateObject private var viewModel = ChatViewModel()
    @Binding var currentUser: User?
    @State private var isCreatingChat = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.chats) { chat in
                    NavigationLink(destination: ChatDetailView(chat: chat, currentUser: $currentUser)) {
                        VStack(alignment: .leading) {
                            Text(chat.name)
                            Text(chat.lastMessage)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Chats")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isCreatingChat = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isCreatingChat) {
                CreateChatView(isCreatingChat: $isCreatingChat, currentUser: $currentUser)
            }
            .onAppear {
                if let user = currentUser {
                    viewModel.fetchChats(for: user.id)
                }
            }
        }
    }
}
*/

/*
struct ChatsListView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    @Binding var currentUser: User?
        
        @State private var chats = [Chat]()
        @State private var isCreatingChat = false

        var body: some View {
            NavigationView {
                List(viewModel.chats) { chat in
                    NavigationLink(destination: ChatDetailView(chat: chat, currentUser: $currentUser)) {
                        Text("Chat with \(chat.participants.joined(separator: ", "))")
                    }
                }
                .navigationTitle("Chats")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isCreatingChat = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $isCreatingChat) {
                    CreateChatView(isCreatingChat: $isCreatingChat, currentUser: $currentUser)
                }
                .onAppear {
                   // viewModel.fetchChats(for: currentUser!.id)
                }
            }
//            NavigationView {
//                List(viewModel.chats) { chat in
//                    NavigationLink(destination: ChatDetailView(chatId: chat.id!)) {
//                        Text(chat.type == "private" ? "Private Chat" : "Group Chat")
//                    }
//                }
//                .navigationTitle("Chats")
//                .onAppear {
//                    
//                    if let user = currentUser {
//                        viewModel.fetchChats(for: user.id)
//                    }
//                    
//                }
//            }
//        }
            
            
            
            
            
            
        }

//        func fetchChats() {
//            // Загрузка чатов текущего пользователя из Firestore
//            guard let userId = Auth.auth().currentUser?.uid else { return }
//
//            Firestore.firestore().collection("chats")
//                .whereField("members", arrayContains: userId)
//                .addSnapshotListener { snapshot, error in
//                    if let error = error {
//                        print("Error fetching chats: \(error)")
//                        return
//                    }
//                    self.chats = snapshot?.documents.compactMap { document in
//                        try? document.data(as: Chat.self)
//                    } ?? []
//                }
//        }
        
        
}
*/
