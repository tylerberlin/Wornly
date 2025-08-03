import SwiftUI

struct HomeView: View {
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
        }
    }
}

#Preview {
    HomeView()
}
