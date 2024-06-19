//
//  ChatCrud.swift
//  JoyFlow
//
//  Created by god on 06/06/2024.
//

import RealmSwift

// Messaging model
class ChatMessage: Object, Identifiable {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var senderId: String = ""
    @objc dynamic var senderName: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var imageUrl: String? = nil
    @objc dynamic var timestamp: Date = Date()

    override static func primaryKey() -> String? {
        return "id"
    }
}

// Save measage to DB
func saveMessage(_ message: ChatMessage) {
    let realm = try! Realm()
    try! realm.write {
        realm.add(message)
    }
}

// Get message from DB
func fetchMessages() -> [ChatMessage] {
    let realm = try! Realm()
    let results = realm.objects(ChatMessage.self).sorted(byKeyPath: "timestamp", ascending: true)
    return Array(results)
}
