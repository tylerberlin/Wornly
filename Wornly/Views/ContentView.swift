//
//  ContentView.swift
//  Wornly
//
//  Created by Tyler Berlin on 7/29/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("wornlyColorScheme") private var colorScheme: String = "system"

    var body: some View {
        TabView {
            HomeScreen(colorScheme: $colorScheme)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ClosetScreen()
                .tabItem {
                    Label("Closet", systemImage: "tshirt")
                }
            OutfitsScreen()
                .tabItem {
                    Label("Outfits", systemImage: "figure.dress.line.vertical.figure")
                }
        }
        .preferredColorScheme({
            switch colorScheme {
            case "light": return .light
            case "dark": return .dark
            default: return nil
            }
        }())
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ClothingItem.self, inMemory: true)
}
