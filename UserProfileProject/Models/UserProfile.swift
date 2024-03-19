//
//  UserProfile.swift
//  UserProfileProject
//
//  Created by Alexey Kiselev on 19.03.2024.
//
import SwiftUI

struct UserProfile: Codable {
    var firstName: String = ""
    var lastName: String = ""
    var patronymic: String = ""
    var nickname: String = ""
    var email: String = ""
    var phone: String = ""
    var telegram: String = ""
    var photoURL: String?
}
