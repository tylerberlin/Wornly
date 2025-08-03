import SwiftUI

struct HomeScreen: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to Wornly!")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Your personal virtual closet and outfit creator.")
                .font(.title3)
                .padding(.top, 8)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    HomeScreen()
}
