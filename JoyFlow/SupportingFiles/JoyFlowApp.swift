//
//  JoyFlowApp.swift
//  JoyFlow
//
//  Created by user on 31/05/2024.
//

import SwiftUI
import FirebaseCore
import RealmSwift
import UIKit
import Firebase
import RealmSwift

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Initialize Firebase
        FirebaseApp.configure()
        
        // Initialize Realm with encryption
        let key: Data
        if let savedKey = getEncryptionKey() {
            key = savedKey
        } else {
            key = generateEncryptionKey()
            saveEncryptionKey(key: key)
        }
               
        let config = Realm.Configuration(encryptionKey: key)
        Realm.Configuration.defaultConfiguration = config
        
        // Check if the Realm file exists and is accessible
        do {
            _ = try Realm()
        } catch {
            print("Error initializing Realm: \(error.localizedDescription)")
            // In case of decryption failure, delete existing Realm file
            let fileManager = FileManager.default
            if let url = Realm.Configuration.defaultConfiguration.fileURL {
                try? fileManager.removeItem(at: url)
                // Try to recreate the Realm file
                do {
                    _ = try Realm()
                } catch {
                    print("Error recreating Realm: \(error.localizedDescription)")
                }
            }
        }
        
        return true
    }
}






@main
struct JoyFlowApp: SwiftUI.App {
    
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
