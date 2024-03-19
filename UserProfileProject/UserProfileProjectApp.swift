//
//  UserProfileProjectApp.swift
//  UserProfileProject
//
//  Created by Alexey Kiselev on 19.03.2024.
//

import SwiftUI

@main
struct UserProfileApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
    }
}
