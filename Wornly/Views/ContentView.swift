//
//  ContentView.swift
//  Wornly
//
//  Created by Tyler Berlin on 7/29/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var onLogout: () -> Void = {}

    var body: some View {
        TabView {
            HomeView(onLogout: onLogout)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ClosetView()
                .tabItem {
                    Label("Closet", systemImage: "tshirt")
                }
            OutfitsView()
                .tabItem {
                    Label("Outfits", systemImage: "figure.dress.line.vertical.figure")
                }
        }
    }
}

#Preview {
    ContentView(onLogout: {})
        .modelContainer(for: ClothingItem.self, inMemory: true)
}
