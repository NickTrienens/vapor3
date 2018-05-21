//
//  TodoViewModel.swift
//  v3Todos
//
//  Created by Nicholas Trienens on 5/21/18.
//

import Foundation
import RxSwift
import RxCocoa

class TodoViewModel {
	let disposeBag = DisposeBag()
	let client: Client
	let items = BehaviorRelay<[Todo]>(value: [])
	let deviceName: String

	init(_ client: Client, deviceName: String) {
		self.client = client
		self.deviceName = deviceName
		loadData()
	}
	
	func loadData() {
		client.getTodos()
			.subscribe(
				onSuccess: { todos in
					print(todos)
					self.items.accept(todos)

			},
				onError: { err in
					print(err)
			})
			.disposed(by: disposeBag)
	}
	
	
	func addTodo() {
		print("add todo")
		client.postTodo(Todo(title: "client created", creator: self.deviceName))
			.subscribe(
				onSuccess: { todo in
					print(todo)
					self.items.accept( self.items.value + [todo] )

			},
				onError: { err in
					print(err)
			})
			.disposed(by: disposeBag)
	}
}
