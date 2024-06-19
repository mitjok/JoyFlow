//
//  Task.swift
//  JoyFlow
//
//  Created by god on 17/06/2024.
//

import Foundation
import RealmSwift

class Task: Object, Identifiable, Codable {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var details: String = ""  // Переименовано из description в details
    @objc dynamic var date: Date = Date()
    @objc dynamic var streamerId: String = ""
    @objc dynamic var managerId: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
    
    // Добавляем инициализатор
    convenience init(id: String = UUID().uuidString, title: String, details: String, date: Date, streamerId: String, managerId: String) {
        self.init()
        self.id = id
        self.title = title
        self.details = details
        self.date = date
        self.streamerId = streamerId
        self.managerId = managerId
    }
}

