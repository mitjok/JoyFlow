//
//  UserViewModel.swift
//  JoyFlow
//
//  Created by god on 14/06/2024.
//

//struct User: Identifiable, Codable, Hashable {
//    var id: String
//    var name: String
//    var email: String
//    var role: String
//    
//    static func == (lhs: User, rhs: User) -> Bool {
//        return lhs.id == rhs.id
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
import Foundation
import RealmSwift

class User: Object, Identifiable, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var role: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
