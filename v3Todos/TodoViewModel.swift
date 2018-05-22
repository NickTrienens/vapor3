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
	
	let edittableTodo = BehaviorRelay<Todo?>(value: nil)
	let editingStatus = BehaviorRelay<LoadResult<Bool>>(value: .none)
	
	init(_ client: Client, deviceName: String) {
		self.client = client
		self.deviceName = deviceName
		loadData()
		setupBindings()
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
	
	func saveTodo(_ todo: Todo) {
		print("save todo")
		editingStatus.accept(.loading)
		client.postTodo(todo)
			.subscribe(
				onSuccess: { todo in
					print(todo)
					self.items.accept( self.items.value.replace(todo) )
					self.editingStatus.accept(.success(value: true))
				},
				onError: { err in
					print(err)
					self.editingStatus.accept(.error(error: err))
			})
			.disposed(by: disposeBag)
	}
	
	func reorder(_ todos: [Todo]) {
		print("reorder todo")
		
	}
	
	func delete(_ todos: [Todo]) {
		print("delete todo")
		editingStatus.accept(.loading)
		
		var deletes = [Observable<Void>]()
		
		for todo in todos {
			deletes.append(client.deleteTodo(todo).asObservable())
		}
		
		Observable.combineLatest(deletes)
			.subscribe(onNext: { _ in
					self.editingStatus.accept(.none)
					self.loadData()
				}, onError: { err in
					self.editingStatus.accept(.error(error: err))
			})
			.disposed(by: disposeBag)
		
	}
	
	func setupBindings() {
		edittableTodo
			.filterNil()
			.subscribe(onNext: { todo in
				self.saveTodo(todo)
			})
			.disposed(by: disposeBag)
	}
}
