 import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
	
	init() {
		print("TodoController created \(self)")
	}
	
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
        return Todo.query(on: req).all()
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {

        return try req.content.decode(Todo.self).flatMap { todo in
			print(todo)
			if let id = todo.id {
				return try Todo.find(id, on: req).flatMap { item in
					guard item != nil else {
						throw Abort(.notFound, reason: "Could not find item to update.")
					}
					return todo.save(on: req)
				}

			} else {
				return todo.save(on: req)
			}
			
        }
    }

    /// Deletes a parameterized `Todo`.
	func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
}
