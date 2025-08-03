import SwiftUI

struct HomeView: View {
    var onLogout: () -> Void = {}
    @State private var showingSettings = false
    @State private var selectedScheme: ColorScheme? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                Image(systemName: "tshirt.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .foregroundStyle(.blue)
                    .shadow(radius: 7)
                Text("Welcome to Wornly!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Your virtual closet and outfit planner.")
                    .font(.title3)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding()
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsSheet(selectedScheme: $selectedScheme, onLogout: {
                    showingSettings = false
                    onLogout()
                })
            }
            .preferredColorScheme(selectedScheme)
        }
    }
}

struct SettingsSheet: View {
    @Binding var selectedScheme: ColorScheme?
    var onLogout: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appearance")) {
                    Picker("Color Scheme", selection: $selectedScheme) {
                        Text("System").tag(ColorScheme?.none)
                        Text("Light").tag(ColorScheme?.some(.light))
                        Text("Dark").tag(ColorScheme?.some(.dark))
                    }
                }

                Section {
                    Button(role: .destructive) {
                        onLogout()
                        dismiss()
                    } label: {
                        Label("Log Out", systemImage: "arrow.backward.square")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    HomeView(onLogout: {})
}
