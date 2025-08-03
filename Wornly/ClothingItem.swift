import SwiftData
import Foundation

@Model
class ClothingItem: Identifiable {
    let id: UUID
    var name: String
    var category: String
    var brand: String
    var imageData: Data?
    var dateAdded: Date
    
    init(name: String, category: String, brand: String = "", imageData: Data? = nil, dateAdded: Date = Date()) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.brand = brand
        self.imageData = imageData
        self.dateAdded = dateAdded
    }
}
