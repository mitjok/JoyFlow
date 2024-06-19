//
//  FirestoreModel.swift
//  JoyFlow
//
//  Created by god on 07/06/2024.
//

import Foundation
import FirebaseFirestore
import RealmSwift

class Message: Object, Identifiable, Codable {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var senderId: String = ""
    @objc dynamic var senderName: String = ""
    @objc dynamic var text: String?
    @objc dynamic var timestamp: Date = Date()
}

class Chat: Object, Identifiable, Codable {
    @objc dynamic var id: String?
    @objc dynamic var name: String = ""
    @objc dynamic var lastMessage: String = ""
    @objc dynamic var isManagerChat: Bool = false
    var participants = List<String>()
    
    static func oneOnOneChatID(for participants: [String]) -> String {
        return participants.sorted().joined(separator: "_")
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

/*
 struct Message: Identifiable, Codable {
 @DocumentID var id: String?
 var senderId: String
 var senderName: String
 var text: String?
 var imageUrl: String?
 var audioUrl: String?
 var timestamp: Date
 var isRead: Bool?
 }
 */





