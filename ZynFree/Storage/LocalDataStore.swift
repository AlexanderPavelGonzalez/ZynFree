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
    private let streakStoreKey = "streakStore"
    
    private init() {}
    
    // MARK: - StreakStore
    
    func saveStreakStore(_ store: StreakStore) {
        if let encoded = try? JSONEncoder().encode(store) {
            userDefaults.set(encoded, forKey: streakStoreKey)
        }
    }
    
    func loadStreakStore() -> StreakStore {
        guard let data = userDefaults.data(forKey: streakStoreKey),
              let decoded = try? JSONDecoder().decode(StreakStore.self, from: data) else {
            // Return empty store if none exists
            return StreakStore()
        }
        return decoded
    }
    
    func updateStreakStore(_ store: StreakStore) {
        saveStreakStore(store)
    }
    
    func deleteStreakStore() {
        userDefaults.removeObject(forKey: streakStoreKey)
    }
}

