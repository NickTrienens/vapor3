
/// A single entry of a Todo list.
final class Todo: Codable {
    /// The unique identifier for this `Todo`.
    var id: Int?

    /// A title describing what this `Todo` entails.
    var title: String

	var creator: String
	
    /// Creates a new `Todo`.
	init(id: Int? = nil, title: String, creator:String) {
        self.id = id
        self.title = title
		self.creator = creator
    }
}
