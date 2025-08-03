import SwiftUI

struct OutfitsView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Outfits")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Here you’ll be able to view and create outfits.")
                .font(.title3)
                .padding(.top, 8)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    OutfitsView()
}
