import Vapor

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
    // your code here
	let conn = try app.newConnection(to: .sqlite).wait()
	defer { conn.close() }
	
	let todos = try Todo.query(on: conn).all().wait()

	for todo in todos{
		try todo.delete(on: conn).wait()
	}
	try Todo(id: nil, title: "Testing", creator: "nick").save(on: conn).wait()

}
