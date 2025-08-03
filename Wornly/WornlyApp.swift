//
//  WornlyApp.swift
//  Wornly
//
//  Created by Tyler Berlin on 7/29/25.
//

// NOTE: If you encounter an Info.plist error related to multiple Info.plist files,
// please check your Xcode project settings and remove or exclude any extra Info.plist files
// from the app target to resolve the conflict.

import SwiftUI
import SwiftData

@main
struct WornlyApp: App {
    @State private var isLoggedIn = false

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            ClothingItem.self,
            Outfit.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView(onLogout: { isLoggedIn = false })
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
