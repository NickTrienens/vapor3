
import Foundation

/// A single entry of a Todo list.
final class Todo: Codable, CustomStringConvertible, Equatable {
    /// The unique identifier for this `Todo`.
    var id: Int?

    /// A title describing what this `Todo` entails.
    var title: String

	var creator: String
	var createdAt: Date
	
    /// Creates a new `Todo`.
	init(id: Int? = nil, title: String, creator:String, createdAt: Date = Date()) {
        self.id = id
        self.title = title
		self.creator = creator
		self.createdAt = createdAt
    }
	
	public var description: String {
		return "\(title) \(creator) @ \(createdAt)"
	}
	
	public static func == (lhs: Todo, rhs: Todo) -> Bool {
		return lhs.id == rhs.id
	}

}
