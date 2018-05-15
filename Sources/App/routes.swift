import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
	
	
	router.get("users", Int.parameter) { req -> String in
		 let id = try req.parameters.next(Int.self)
		 return "User #\(id)"
	 }

	
//	router.get("hello/", String.parameter ) { req in
//		//print (req.parameters)
//		let name = "nick"
//			//try req.parameters.next(String.self)
//
//		return "Hello/, \(name)!"
//	}

    router.get("/") { req in
        return "Hello, (root)world!"
    }
    // Example of configuring a controller
    let todoController = TodoController()
	router.get("todos", use: { req -> Future<[Todo]> in
		
		let todoController = TodoController()
		return try todoController.index(req)
	})
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
