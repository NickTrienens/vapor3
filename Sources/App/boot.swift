import Vapor

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
    // your code here
	app.withNewConnection(to: .sqlite) { conn in
		Todo(id: nil, title: "Testing", creator: "nick").save(on: conn)
	}
	
}
