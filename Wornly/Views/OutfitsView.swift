import SwiftUI
import SwiftData

struct OutfitsView: View {
    @Query(sort: \Outfit.dateCreated, order: .reverse) private var outfits: [Outfit]
    @Query(sort: \ClothingItem.dateAdded, order: .reverse) private var clothingItems: [ClothingItem]
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddSheet = false
    @State private var isRefreshing = false

    var body: some View {
        NavigationStack {
            if outfits.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    Text("Here you’ll be able to view and create outfits.")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Button("Add an Outfit") {
                        showingAddSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
                .padding()
                .navigationTitle("Outfits")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddSheet = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            } else {
                List {
                    ForEach(outfits) { outfit in
                        NavigationLink {
                            OutfitDetailView(outfit: outfit)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(outfit.name)
                                        .font(.headline)
                                    Text(outfit.dateCreated, style: .date)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .refreshable {
                    isRefreshing = true
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    isRefreshing = false
                }
                .navigationTitle("Outfits")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Button {
                                Task {
                                    isRefreshing = true
                                    try? await Task.sleep(nanoseconds: 500_000_000)
                                    isRefreshing = false
                                }
                            } label: {
                                Image(systemName: "arrow.clockwise")
                            }
                            Button {
                                showingAddSheet = true
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddOutfitSheet(isPresented: $showingAddSheet, clothingItems: clothingItems)
        }
    }
}

struct AddOutfitSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    let clothingItems: [ClothingItem]
    var onOutfitAdded: ((Outfit) -> Void)? = nil
    @State private var name = ""
    @State private var selectedClothingIDs: Set<UUID> = []
    @State private var searchText = ""

    var filteredClothingItems: [ClothingItem] {
        if searchText.isEmpty { return clothingItems }
        return clothingItems.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Outfit Name") {
                    TextField("Enter name", text: $name)
                }
                Section("Add Clothing") {
                    ForEach(filteredClothingItems) { item in
                        Button(action: {
                            if selectedClothingIDs.contains(item.id) {
                                selectedClothingIDs.remove(item.id)
                            } else {
                                selectedClothingIDs.insert(item.id)
                            }
                        }) {
                            HStack {
                                Text(item.name)
                                Spacer()
                                if selectedClothingIDs.contains(item.id) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search clothing")
            .navigationTitle("Add Outfit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let newOutfit = Outfit(name: name, dateCreated: Date())
                        // Add selected clothing items to outfit
                        for id in selectedClothingIDs {
                            if let clothingItem = clothingItems.first(where: { $0.id == id }) {
                                newOutfit.clothingItems.append(clothingItem)
                            }
                        }
                        modelContext.insert(newOutfit)
                        try? modelContext.save()
                        onOutfitAdded?(newOutfit)
                        isPresented = false
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    let sampleClothingItems = [
        ClothingItem(name: "Blue Jeans", category: "Pants", dateAdded: Date()),
        ClothingItem(name: "White T-Shirt", category: "Shirts", dateAdded: Date()),
        ClothingItem(name: "Black Jacket", category: "Outerwear", dateAdded: Date())
    ]
    AddOutfitSheet(isPresented: .constant(true), clothingItems: sampleClothingItems)
}
