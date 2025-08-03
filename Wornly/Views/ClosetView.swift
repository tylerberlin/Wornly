import SwiftUI
import SwiftData
import PhotosUI

struct ClosetView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor<ClothingItem>(\ClothingItem.dateAdded, order: .reverse)]) var clothingItems: [ClothingItem]
    @State var showingAddSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(clothingItems) { item in
                    HStack {
                        if let imageData = item.imageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipped()
                                .cornerRadius(8)
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                )
                        }
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.category)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let item = clothingItems[index]
                        modelContext.delete(item)
                    }
                    try? modelContext.save()
                }
            }
            .navigationTitle("Closet")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddClothingView(isPresented: $showingAddSheet)
                    .environment(\.modelContext, modelContext)
            }
        }
    }
}

#Preview {
    ClosetView()
}
