//
//  ShiftsView.swift
//  JoyFlow
//
//  Created by god on 02/06/2024.
//

import SwiftUI

struct ShiftsView: View {
    
    var body: some View {
        VStack {
            Text("This is the Some task screen")
                .font(.largeTitle)
                .padding()
        }
        .navigationTitle("Task Screen")
    }
    
}
struct ShiftsView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftsView()
    }
}

/*
struct MessageView11: View {
    let name: String
    
    private var messageVM = MessageViewModel()
    @State private var typeMessage = ""
    
    init(name: String) {
        self.name = name
    }
    
    var body: some View {
        VStack {
            List(messageVM.messages, id: \.id) {message in
                if message.name == name {
                    MessageRow(message: message.message, isMyMessage: true, user:message.name, date: message.createAt)
                } else {
                    MessageRow(message: message.message, isMyMessage: false, user:message.name, date: message.createAt)
                }
            }
            .navigationBarTitle("Chats", displayMode: .inline)
            HStack {
                TextField("Message", text: $typeMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button {
                    messageVM.addMessage(message: typeMessage, name: name)
                    typeMessage = ""
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                }
            }
            .padding()
        }
    }
}*/



/*

 struct ChatListView: View {
     @State private var chats = [Chat]()
     @State private var isCreatingChat = false

     var body: some View {
         NavigationView {
             List(chats, id: \.id) { chat in
                 NavigationLink(destination: ChatDetailView(chat: chat)) {
                     Text("Chat with \(chat.members.joined(separator: ", "))")
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
                 CreateChatView(isCreatingChat: $isCreatingChat)
             }
             .onAppear {
                 fetchChats()
             }
         }
     }

     func fetchChats() {
         // Загрузка чатов текущего пользователя из Firestore
         guard let userId = Auth.auth().currentUser?.uid else { return }

         Firestore.firestore().collection("chats")
             .whereField("members", arrayContains: userId)
             .addSnapshotListener { snapshot, error in
                 if let error = error {
                     print("Error fetching chats: \(error)")
                     return
                 }
                 self.chats = snapshot?.documents.compactMap { document in
                     try? document.data(as: Chat.self)
                 } ?? []
             }
     }
 }

 struct ChatDetailView: View {
     var chat: Chat
     @State private var messages = [Message]()

     var body: some View {
         VStack {
             List(messages, id: \.id) { message in
                 Text(message.content)
             }
             .onAppear {
                 fetchMessages()
             }

             // UI для отправки сообщения (не реализован)
         }
         .navigationTitle("Chat")
     }

     func fetchMessages() {
         Firestore.firestore().collection("chats").document(chat.id).collection("messages")
             .order(by: "timestamp", descending: false)
             .addSnapshotListener { snapshot, error in
                 if let error = error {
                     print("Error fetching messages: \(error)")
                     return
                 }
                 self.messages = snapshot?.documents.compactMap { document in
                     try? document.data(as: Message.self)
                 } ?? []
             }
     }
 }

 struct Message: Identifiable, Codable {
     var id: String
     var senderId: String
     var content: String
     var timestamp: Date
 }




 
 */










