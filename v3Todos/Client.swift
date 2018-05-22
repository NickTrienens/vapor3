//
//  Client.swift
//  v3 todos
//
//  Created by Nicholas Trienens on 5/15/18.
//

import Foundation
import Moya
import RxSwift

public class Client {
	let service: MoyaProvider<TodoTarget>
	
	init() {
		service = MoyaProvider<TodoTarget>(plugins: [NetworkLoggerPlugin(verbose: false, cURL: true)])
	}
	
	func getTodos() -> PrimitiveSequence<SingleTrait, [Todo]> {
		return service.rx
				.request(.getTodos())
				.debugBody()
				.mapWithError([Todo].self)
	}
	func postTodo(_ todo: Todo) -> PrimitiveSequence<SingleTrait, Todo> {
		return service.rx
				.request(.postTodo(todo))
				.debugBody()
				.mapWithError(Todo.self)
	}
	
	func deleteTodo(_ todo: Todo) -> PrimitiveSequence<SingleTrait, Void> {
		guard let target = TodoTarget.deleteTodo(todo) else {
			return PrimitiveSequence<SingleTrait, Void>.error(TodoError.requestInvalid)
		}
		return service.rx
			.request(target)
			.debugBody()
			.filterSuccessfulStatusCodes()
			.map { _ in return () }
	}
}

struct TodoTarget: TargetType {

	var task: Task
	let method: Moya.Method
	let path: String
	
	var baseURL: URL = URL(string: "http://localhost:8080/")!
	var sampleData: Data { return " ".data(using: String.Encoding.utf8)! }
	var headers: [String: String]? {
		var headers = [String: String]()
		headers["Content-Type"] = "application/json"
		return nil
	}
	
	init(method: Moya.Method, path: String, task: Task = .requestPlain  ) {
		self.method  = method
		self.path = path
		self.task = task
	}
	
	static func getTodos() -> TodoTarget {
		return TodoTarget(method: .get, path: "todos/")
	}
	static func postTodo(_ todo: Todo) -> TodoTarget {
		let coder = JSONEncoder()
		coder.dateEncodingStrategy = .iso8601
		return TodoTarget(method: .post, path: "todos/", task: .requestCustomJSONEncodable(todo, encoder: coder))
	}
	static func deleteTodo(_ todo: Todo) -> TodoTarget? {
		guard let tid = todo.id else { return nil }
		return TodoTarget(method: .delete, path: "todos/\(tid)")
	}
}


extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
	
	public func debugBody() -> Single<ElementType> {
		return self
			.do (
				onSuccess: { res in
					try print( res.mapString() )
			}
		)
	}
	
	/// Maps received data at key path into a Decodable object. If the conversion fails, the signal errors.
	public func mapWithError<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> Single<D> {

		decoder.dateDecodingStrategy = .iso8601
		return flatMap { response -> Single<D> in
			
			do {
				return Single.just(try response.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData))
			} catch {
				// try to map to an error message form the server
				if let serverError = try? response.map(ServerError.self, using: decoder, failsOnEmptyData: failsOnEmptyData) {
					throw TodoError.serverError(error: serverError)
				}
				throw(error)
			}
		}
	}
}

enum TodoError: Error {
	case any
	case requestInvalid
	case serverError(error: ServerError)
	case valueUncastable
}
struct ServerError : Codable {
	
	var error: Bool
	var reason: String
	
	func convertToNSError() -> NSError {
		
		let userInfo: [AnyHashable: Any] = [
			NSLocalizedDescriptionKey :  NSLocalizedString("Error", value: reason, comment: ""),
			NSLocalizedFailureReasonErrorKey : NSLocalizedString("Error", value: reason, comment: "")
		]
		return NSError(domain: "HTTPError", code: 505, userInfo: userInfo as? [String : Any])
	}
}


