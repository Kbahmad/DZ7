//
//  KeychainHelper.swift
//  AuthOnboardingSUI
//  Created by brfsu
//
import Foundation

final class KeychainHelper
{
    static let shared = KeychainHelper()
    
    private init() {}
    
    // MARK: - Save and Update
    
    // Save data into Keychain
    func save(_ data: Data, service: String, account: String) {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as [CFString : Any] as CFDictionary
        
        // Add or update item in Keychain
        var status  = SecItemAdd(query, nil)
        
        // Check if item already exists or needs to be updated
        if status == errSecDuplicateItem || status == -25299 {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account
            ] as [CFString : Any] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            
            status = SecItemUpdate(query, attributesToUpdate)
        }
        
        if status != errSecSuccess || status != 0 {
            print("Error: \(status)")
        }
    }

    // Read data from Keychain
    func read(service: String, account: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        return (result as? Data)
    }
    
    
    // MARK: - Delete
    
    // Delete data from keychain
    func delete(service: String, account: String) {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as [CFString: Any] as CFDictionary
        SecItemDelete(query)
    }
    
    // Mark: - Save Codable
    
    // Save Codable item to Keychain
    func save<T>(_ item: T, service: String, account: String) throws where T: Codable {
        let data = try JSONEncoder().encode(item)
        save(data, service: service, account: account)
    }

    
    // Read Codable item form Keychain
    func read<T>(service: String, account: String, type: T.Type) -> T? where T: Codable {
        guard let data = read(service: service, account: account) else {
            return nil
        }
        
        do {
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            assertionFailure("Fail to decode item for keychain: \(error)")
            return nil
        }
        
    }
}
