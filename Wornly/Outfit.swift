import SwiftData
import Foundation

@Model
class Outfit: Identifiable {
    let id: UUID
    var name: String
    var clothingItems: [ClothingItem]
    var dateCreated: Date
    
    init(name: String, clothingItems: [ClothingItem] = [], dateCreated: Date = Date()) {
        self.id = UUID()
        self.name = name
        self.clothingItems = clothingItems
        self.dateCreated = dateCreated
    }
}
