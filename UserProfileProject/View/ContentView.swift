//
//  ContentView.swift
//  UserProfileProject
//
//  Created by Alexey Kiselev on 19.03.2024.
//

import SwiftUI


struct ContentView: View {
    @State private var isProfilePresented = false

    var body: some View {
        Button("Открыть профиль") {
            isProfilePresented = true
        }
        .sheet(isPresented: $isProfilePresented) {
            ProfileView(userProfile: UserProfile.loadFromUserDefaults() ?? UserProfile(), isPresented: $isProfilePresented)
        }
    }
}

#Preview {
    ContentView()
}
