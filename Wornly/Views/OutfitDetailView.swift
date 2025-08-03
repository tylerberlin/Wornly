import SwiftUI

struct OutfitDetailView: View {
    let outfit: Outfit

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(outfit.name)
                .font(.largeTitle)
                .bold()
            Text("Created: \(outfit.dateCreated, style: .date)")
                .foregroundColor(.secondary)
            Divider()
            Text("Clothing Items:")
                .font(.headline)
            if outfit.clothingItems.isEmpty {
                Text("No items added.")
                    .italic()
            } else {
                ForEach(outfit.clothingItems, id: \.id) { item in
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.body)
                        Text(item.category)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Outfit Details")
    }
}
