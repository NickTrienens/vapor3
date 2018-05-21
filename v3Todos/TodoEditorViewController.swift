//
//  TodoEditorViewController.swift
//  v3Todos
//
//  Created by Nicholas Trienens on 5/21/18.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxFuzz

class TodoEditorViewModel {
	let disposeBag = DisposeBag()
	let client: Client

	let todoObs: BehaviorRelay<Todo>
	
	init(_ client: Client, todo: BehaviorRelay<Todo>) {
		self.client = client
		todoObs = todo
		loadData()
	}
	
	func loadData() {
	}
}

class TodoEditorViewController: BaseViewController {
	
	let viewModel: TodoEditorViewModel
	let textView = UITextView()
	
	public init(_ client: Client, todo: BehaviorRelay<Todo> ) {
		
		viewModel = TodoEditorViewModel(client, todo: todo)
		
		super.init()
		self.title = "Todos"
		
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	func addTableView() {
		view.addSubview(textView)
		
		textView.snp.makeConstraints { make in
			make.edges.equalTo(self.view)
		}
	}
}
