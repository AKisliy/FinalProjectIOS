//
//  UserProfile+UserDefaults.swift
//  UserProfileProject
//
//  Created by Alexey Kiselev on 19.03.2024.
//

import Foundation

extension UserProfile {
    private static let userDataKey = "userProfileData"
    
    // Сохранение данных профиля в UserDefaults
    func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: UserProfile.userDataKey)
        }
    }
    
    // Загрузка данных профиля из UserDefaults
    static func loadFromUserDefaults() -> UserProfile? {
        if let savedUserData = UserDefaults.standard.object(forKey: UserProfile.userDataKey) as? Data {
            if let loadedUserProfile = try? JSONDecoder().decode(UserProfile.self, from: savedUserData) {
                return loadedUserProfile
            }
        }
        return nil
    }
}
