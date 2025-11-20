//
//  LocalDataStore.swift
//  ZynFree
//
//  Created by Alexander Gonzalez on 11/20/25.
//

import Foundation

class LocalDataStore {
    static let shared = LocalDataStore()
    
    private let userDefaults = UserDefaults.standard
    private let addictionDataKey = "addictionData"
    
    private init() {}
    
    func save(_ data: AddictionData) {
        if let encoded = try? JSONEncoder().encode(data) {
            userDefaults.set(encoded, forKey: addictionDataKey)
        }
    }
    
    func load() -> AddictionData? {
        guard let data = userDefaults.data(forKey: addictionDataKey),
              let decoded = try? JSONDecoder().decode(AddictionData.self, from: data) else {
            return nil
        }
        return decoded
    }
    
    func update(_ data: AddictionData) {
        save(data)
    }
    
    func delete() {
        userDefaults.removeObject(forKey: addictionDataKey)
    }
    
    func hasCompletedOnboarding() -> Bool {
        return load() != nil
    }
}

