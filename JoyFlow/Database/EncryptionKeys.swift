//
//  Configuration.swift
//  JoyFlow
//
//  Created by god on 06/06/2024.
//

import RealmSwift
import Security


// Function to get the encryption key from Keychain
func getKey() -> Data {
    let keychainIdentifier = "god.JoyFlow.EncryptionKey"
    let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!

    var query: [NSObject: AnyObject] = [
        kSecClass as NSObject: kSecClassKey as AnyObject,
        kSecAttrApplicationTag as NSObject: keychainIdentifierData as AnyObject,
        kSecAttrKeySizeInBits as NSObject: 512 as AnyObject,
        kSecReturnData as NSObject: kCFBooleanTrue
    ]

    var dataTypeRef: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

    if status == errSecSuccess {
        return dataTypeRef as! Data
    }

    var keyData = Data(count: 64)
    let _ = keyData.withUnsafeMutableBytes { (pointer: UnsafeMutableRawBufferPointer) in
        SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
    }

    query = [
        kSecClass as NSObject: kSecClassKey as AnyObject,
        kSecAttrApplicationTag as NSObject: keychainIdentifierData as AnyObject,
        kSecAttrKeySizeInBits as NSObject: 512 as AnyObject,
        kSecValueData as NSObject: keyData as AnyObject
    ]

    let statusAdd = SecItemAdd(query as CFDictionary, nil)
    assert(statusAdd == errSecSuccess, "Failed to insert the new key in the keychain")

    return keyData
}

// Creating encrypted key
func generateEncryptionKey() -> Data {
    var key = Data(count: 64)
    _ = key.withUnsafeMutableBytes { pointer in
        SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
    }
    return key
}

// Save key to Keychain
func saveEncryptionKey(key: Data) {
    let query: [String: Any] = [
        kSecClass as String: kSecClassKey,
        kSecAttrApplicationTag as String: "god.JoyFlow.realmEncryptionKey",
        kSecValueData as String: key
    ]
    SecItemAdd(query as CFDictionary, nil)
}

// Get key from Keychain
func getEncryptionKey() -> Data? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassKey,
        kSecAttrApplicationTag as String: "god.JoyFlow.realmEncryptionKey",
        kSecReturnData as String: kCFBooleanTrue!,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status == errSecSuccess else { return nil }
    return item as? Data
}
