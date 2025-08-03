import SwiftData
import Foundation

@Model
class ClothingItem: Identifiable {
    let id: UUID
    var name: String
    var category: String
    var imageData: Data?
    var dateAdded: Date
    
    init(name: String, category: String, imageData: Data? = nil, dateAdded: Date = Date()) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.imageData = imageData
        self.dateAdded = dateAdded
    }
}
