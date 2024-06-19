//
//  ChatViewModel.swift
//  JoyFlow
//
//  Created by god on 07/06/2024.
//

import SwiftUI
import FirebaseFirestore
import RealmSwift

class ChatViewModel: ObservableObject {
    @Published var chats = [Chat]()
    @Published var messages = [Message]()
    
    private var db = Firestore.firestore()
    
    func fetchChats(for userId: String) {
        db.collection("chats")
            .whereField("participants", arrayContains: userId)
            .order(by: "isManagerChat", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching chats: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("No documents")
                    return
                }
                self.chats = documents.compactMap { document in
                    try? document.data(as: Chat.self)
                }
                self.updateLastMessages()
            }
    }
    
    func fetchMessages(for chatId: String) {
        db.collection("chats").document(chatId).collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.messages = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: Message.self)
                    } ?? []
                }
            }
    }
    
    func sendMessage(text: String, chatId: String, sender: User) {
        let message = Message()
        message.senderId = sender.id
        message.senderName = sender.name
        message.text = text
        message.timestamp = Date()
        
        do {
            _ = try db.collection("chats").document(chatId).collection("messages").document(message.id).setData(from: message)
            updateLastMessage(for: chatId, with: message.text ?? "")
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    func createChat(with participants: [User], completion: @escaping (Chat) -> Void) {
        let chat = Chat()
        chat.id = Chat.oneOnOneChatID(for: participants.map { $0.id })
        chat.participants.append(objectsIn: participants.map { $0.id })
        chat.name = participants.map { $0.name }.joined(separator: ", ")
        if participants.count == 2 {
            chat.isManagerChat = participants.contains { $0.role == "manager" }
        }        
        do {
            let chatRef = db.collection("chats").document(chat.id!)
            try chatRef.setData(from: chat)
            completion(chat)
        } catch {
            print("Error creating chat: \(error)")
        }
    }
    
    private func updateLastMessage(for chatId: String, with message: String) {
        db.collection("chats").document(chatId).updateData(["lastMessage": message]) { error in
            if let error = error {
                print("Error updating last message: \(error)")
            }
        }
    }
    
    private func updateLastMessages() {
        for chat in chats {
            db.collection("chats").document(chat.id!).collection("messages")
                .order(by: "timestamp", descending: true)
                .limit(to: 1)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error getting last message: \(error)")
                        return
                    }
                    if let document = snapshot?.documents.first, let message = try? document.data(as: Message.self) {
                        if let index = self.chats.firstIndex(where: { $0.id == chat.id }) {
                            self.chats[index].lastMessage = message.text ?? ""
                        }
                    }
                }
        }
    }
}




/*
class ChatViewModel: ObservableObject {
    @Published var chats = [Chat]()
    @Published var messages = [Message]()
    
    private var db = Firestore.firestore()
    
    func fetchChats(for userId: String) {
        db.collection("chats")
            .whereField("participants", arrayContains: userId)
            //.order(by: "isManagerChat", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching chats: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("No documents")
                    return
                }
                self.chats = documents.compactMap { document in
                    try? document.data(as: Chat.self)
                }
                //print("mrChecker Fetched chats: \(self.chats)")
            }
    }
    
    func fetchMessages(for chatId: String) {
        db.collection("chats").document(chatId).collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.messages = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: Message.self)
                    } ?? []
                }
                //print("mrChecker Fetched chats: \(self.messages)")
            }
    }
    
    func sendMessage(text: String, chatId: String, senderId: String, senderName: String) {
        let message = Message()
        message.senderId = senderId
        message.senderName = senderName
        message.text = text
        message.timestamp = Date()
        do {
            _ = try db.collection("chats").document(chatId).collection("messages").addDocument(from: message)
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    func createChat(with participants: [String]) {
        let chat = Chat()
        chat.id = Chat.oneOnOneChatID(for: participants)
        chat.participants.append(objectsIn: participants)
        chat.name = participants.map { getUserName(for: $0) }.joined(separator: ", ")
        //chat.isManagerChat = participants.contains(where: { userId in
            // Предположим, что у вас есть способ определить, является ли пользователь менеджером
          //  return isManager(userId: userId)
        //})
        print("mrChecker \(participants)")
//
//        do {
//            _ = try db.collection("chats").document(chat.id!).setData(from: chat)
//        } catch {
//            print("Error creating chat: \(error)")
//        }
    }
    
    private func getUserName(for userId: String) -> String {
        // Implement a method to get user name by userId
        return "User Name"
    }
    
    private func isManager(userId: String) -> Bool {
        // Implement a method to check if user is a manager
        return false
    }
}*/

/*
class ChatViewModel: ObservableObject {
    
    @Published var chats = [Chat]()
    @Published var messages = [Message]()
    
    // working with firestore
    private var db = Firestore.firestore()
    // Firestore collection name
    //private let collectionName = "enterName"
    
    func fetchChats(for userId: String) {
        db.collection("chats")
                .whereField("participants", arrayContains: userId)
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        print("mrChecker Error fetching chats: \(error.localizedDescription)")
                        return
                    }
                    guard let documents = snapshot?.documents else {
                        print("mrChecker No documents")
                        return
                    }
                    self.chats = documents.compactMap { document in
                        try? document.data(as: Chat.self)
                    }
                    print("mrChecker Fetched chats: \(self.chats)")
                }
        }
    
   
    
    
//
//    func fetchChats(for userId: String) {
//        db.collection("chats")
//            .whereField("participants", arrayContains: userId)
//            .addSnapshotListener { querySnapshot, error in
//                if let error = error {
//                    print("Error getting documents: \(error)")
//                } else {
//                    self.chats = querySnapshot?.documents.compactMap { document in
//                        try? document.data(as: Chat.self)
//                    } ?? []
//                }
//            }
//    }
    
    
    func fetchMessages(for chatId: String) {
        db.collection("chats").document(chatId).collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.messages = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: Message.self)
                    } ?? []
                }
            }
    }
    
    func sendMessage(text: String, chatId: String, senderId: String, senderName: String) {
        let message = Message(senderId: senderId, senderName: senderName, text: text, timestamp: Date())
        do {
            _ = try db.collection("chats").document(chatId).collection("messages").addDocument(from: message)
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    func createChat(with participants: [String]) {
        let chat = Chat(participants: participants)
        do {
            _ = try db.collection("chats").addDocument(from: chat)
        } catch {
            print("Error creating chat: \(error)")
        }
    }
        
    
    /*
    func sendImage(image: UIImage, senderId: String, senderName: String) {
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        if let imageData = image.jpegData(compressionQuality: 1) { // 0.8 compress default
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading image: \(error)")
                    return
                }
                
                storageRef.downloadURL { url, error in
                    if let url = url {
                        let message = Message(senderId: senderId, senderName: senderName, imageUrl: url.absoluteString, timestamp: Date())
                        do {
                            _ = try self.db.collection(self.collectionName).addDocument(from: message)
                        } catch {
                            print("Error adding document: \(error)")
                        }
                    }
                }
            }
        }
    }
    */
    
}

*/
/*

     
     func fetchChats(for userId: String) {
         db.collection("chats")
             .whereField("participants", arrayContains: userId)
             .order(by: "isManagerChat", descending: true)
             .addSnapshotListener { snapshot, error in
                 if let error = error {
                     print("Error fetching chats: \(error.localizedDescription)")
                     return
                 }
                 guard let documents = snapshot?.documents else {
                     print("No documents")
                     return
                 }
                 self.chats = documents.compactMap { document in
                     try? document.data(as: Chat.self)
                 }
             }
     }
     
     func fetchMessages(for chatId: String) {
         db.collection("chats").document(chatId).collection("messages")
             .order(by: "timestamp")
             .addSnapshotListener { querySnapshot, error in
                 if let error = error {
                     print("Error getting documents: \(error)")
                 } else {
                     self.messages = querySnapshot?.documents.compactMap { document in
                         try? document.data(as: Message.self)
                     } ?? []
                 }
             }
     }
     
     func sendMessage(text: String, chatId: String, senderId: String, senderName: String) {
         let message = Message()
         message.senderId = senderId
         message.senderName = senderName
         message.text = text
         message.timestamp = Date()
         
         do {
             _ = try db.collection("chats").document(chatId).collection("messages").document(message.id).setData(from: message)
         } catch {
             print("Error adding document: \(error)")
         }
     }
     
     func createChat(with participants: [String], completion: @escaping (Chat) -> Void) {
         let chat = Chat()
         chat.id = Chat.oneOnOneChatID(for: participants)
         chat.participants.append(objectsIn: participants)
         chat.name = participants.map { getUserName(for: $0) }.joined(separator: ", ")
         chat.isManagerChat = participants.contains(where: { userId in
             // Предположим, что у вас есть способ определить, является ли пользователь менеджером
             return isManager(userId: userId)
         })
         do {
             let chatRef = db.collection("chats").document(chat.id!)
             try chatRef.setData(from: chat)
             completion(chat)
         } catch {
             print("Error creating chat: \(error)")
         }
     }
     
     private func getUserName(for userId: String) -> String {
         // Implement a method to get user name by userId
         return "User Name"
     }
     
     private func isManager(userId: String) -> Bool {
         // Implement a method to check if user is a manager
         return false
     }
 }

 */
