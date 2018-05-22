import Vapor

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
    // your code here
	let conn = try app.newConnection(to: .sqlite).wait()
	defer { conn.close() }
	
//
//	Todo.query(on: conn).all().whenSuccess({ (todos) in
//		for todo in todos{
//			todo.delete(on: conn)
//		}
//	    Todo(id: nil, title: "Testing", creator: "nick").save(on: conn)
//	})
	
//	let todos = try Todo.query(on: conn).all().wait()
//	for todo in todos{
//		try todo.delete(on: conn).wait()
//	}
	
	
	

}
