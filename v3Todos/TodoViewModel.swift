//
//  TodoViewModel.swift
//  v3Todos
//
//  Created by Nicholas Trienens on 5/21/18.
//

import Foundation
import RxSwift
import RxCocoa
import RxFuzz

class TodoViewModel {
	let disposeBag = DisposeBag()
	let client: Client
	let deviceName: String
	
	
	let loadingStatus = BehaviorRelay<LoadStatus>(value: .none)
	let items = BehaviorRelay<[Todo]>(value: [])
	let editting = BehaviorRelay<Bool>(value: false)

	init(_ client: Client, deviceName: String) {
		self.client = client
		self.deviceName = deviceName
		loadData()
	}
	
	func toggleEditting() {
		editting.accept(!editting.value)
	}
	
	func loadData() {
		loadingStatus.accept(.loading)
		client.getTodos()
			.subscribe(
				onSuccess: { todos in
					print(todos)
					self.items.accept(todos)
					self.loadingStatus.accept(.none)
			},
				onError: { err in
					print(err)
					self.loadingStatus.accept(.error(error: err))
			})
			.disposed(by: disposeBag)
	}
	
	func addTodo() {
		print("add todo")
		loadingStatus.accept(.loading)
		client.postTodo(Todo(title: "client created", creator: self.deviceName))
			.subscribe(
				onSuccess: { todo in
					print(todo)
					self.items.accept( self.items.value + [todo] )
					self.loadingStatus.accept(.none)
				},
				onError: { err in
					print(err)
					self.loadingStatus.accept(.error(error: err))

			})
			.disposed(by: disposeBag)
	}
}
