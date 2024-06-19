//
//  ChatDetailView.swift
//  JoyFlow
//
//  Created by god on 14/06/2024.
//

import SwiftUI
import RealmSwift

struct ChatDetailView: View {
    var chat: Chat
    @StateObject private var viewModel = ChatViewModel()
    @State private var messageText = ""
    @Binding var currentUser: User?
    
    var body: some View {
        VStack {
            List(viewModel.messages) { message in
                VStack(alignment: .leading) {
                    if message.senderId == currentUser?.id {
                        MessageRow(message: message.text ?? "", isMyMessage: true, user: message.senderName, date: message.timestamp)
                    } else {
                        MessageRow(message: message.text ?? "", isMyMessage: false, user: message.senderName, date: message.timestamp)
                    }
                }
            }
            
            HStack {
                TextField("Enter message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    if let user = currentUser {
                        viewModel.sendMessage(text: messageText, chatId: chat.id!, sender: user)
                        messageText = ""
                    }
                }) {
                    Text("Send")
                }
            }
            .padding()
        }
        .navigationBarTitle(getChatName(), displayMode: .inline)
        .onAppear {
            viewModel.fetchMessages(for: chat.id!)
        }
    }
    
    private func getChatName() -> String {
        if chat.name.isEmpty {
            let otherParticipants = chat.participants.filter { $0 != currentUser?.id }
            return otherParticipants.joined(separator: ", ")
        } else {
            return chat.name
        }
    }
}



/*
struct ChatDetailView: View {
    var chat: Chat
    @StateObject private var viewModel = ChatViewModel()
    @State private var messageText = ""
    @Binding var currentUser: User?
    
    var body: some View {
        VStack {
            List(viewModel.messages) { message in
                VStack(alignment: .leading) {
                    if message.senderId == currentUser?.id {
                        MessageRow(message: message.text ?? "", isMyMessage: true, user: message.senderName, date: message.timestamp)
                    } else {
                        MessageRow(message: message.text ?? "", isMyMessage: false, user: message.senderName, date: message.timestamp)
                    }
                }
            }
            
            HStack {
                TextField("Enter message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    if let user = currentUser {
                        viewModel.sendMessage(text: messageText, chatId: chat.id!, senderId: user.id, senderName: user.name)
                        messageText = ""
                    }
                }) {
                    Text("Send")
                }
            }
            .padding()
        }
        .navigationBarTitle("Chat", displayMode: .inline)
        .onAppear {
            viewModel.fetchMessages(for: chat.id!)
        }
    }
}*/


/*
struct ChatDetailView: View {
    var chat: Chat
    @StateObject private var viewModel = ChatViewModel()
    @State private var messageText = ""
    @Binding var currentUser: User?

    
    var body: some View {
        VStack {
            List(viewModel.messages) { message in
                VStack(alignment: .leading) {
                    
                    
                    if  message.senderId == currentUser?.id {
                        MessageRow(message: message.text ?? "", isMyMessage: true, user:message.senderName, date: message.timestamp)
                    } else {
                        MessageRow(message: message.text ?? "", isMyMessage: false, user:message.senderName, date: message.timestamp)
                    }
                    //                    Text(message.senderName).font(.headline)
                    //                    if let text = message.text {
                    //                        Text(text)
                    //                    }
                    //                    if let imageUrl = message.imageUrl {
                    //                        AsyncImage(url: URL(string: imageUrl))
                    //                            .frame(width: 200, height: 200)
                    //                            .clipped()
                    //                    }
                }
            }
            
            HStack {
                TextField("Enter message...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    if let user = currentUser {
                        viewModel.sendMessage(text: messageText, chatId: chat.id!, senderId: user.id, senderName: user.name)
                        messageText = ""
                    }
                    //                    viewModel.sendMessage(text: messageText, chatId: chatId, senderId: userId, senderName: userName)
                    //                    messageText = ""
                    
                    
                }) {
                    Text("Send")
                }
            }.padding()
        }
        .navigationBarTitle("Chat", displayMode: .inline)
        .onAppear {
            viewModel.fetchMessages(for: chat.id!)
        }
    }
}
*/
