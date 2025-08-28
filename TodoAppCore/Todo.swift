import Foundation

// * Create the `Todo` struct.
// * Ensure it has properties: id (UUID), title (String), and isCompleted (Bool).
public struct Todo: Codable, CustomStringConvertible {
    
    let id: UUID
    var title: String
    var isCompleted: Bool
    
    init(title: String) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
    }
    
    // CustomStringConvertible implementation
    public var description: String {
        let emoji = isCompleted ? "✅" : "❌"
        return "\(emoji) \(title)"
    }
    
}
