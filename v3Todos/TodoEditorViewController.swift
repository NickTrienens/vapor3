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

class TodoEditorViewController: BaseViewController {
	
	let viewModel: TodoEditorViewModel
	
	let titleView = UITextField()
	let textView = UITextView()
	let creatorLabel = UILabel()
	let createdAtLabel = UILabel()
	let saveButton = UIButton()
	
	public init(todo: BehaviorRelay<Todo> ) {
		viewModel = TodoEditorViewModel(todo: todo)
		super.init()
		self.title = "Todos"
		
	}
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addTableView()
		setupBindings()
	}
	
	func addTableView() {
		view.addSubview(titleView)
		view.addSubview(textView)
		view.addSubview(creatorLabel)
		view.addSubview(createdAtLabel)
		view.addSubview(saveButton)
		
		titleView.snp.makeConstraints { make in
			make.leading.trailing.equalTo(self.view).inset(10)
			make.top.equalTo(self.view.snp.topMargin).inset(20)
			make.height.greaterThanOrEqualTo(20)
		}
		textView.snp.makeConstraints { make in
			make.leading.trailing.equalTo(self.view).inset(10)
			make.top.equalTo(titleView.snp.bottom).offset(10)
			make.height.greaterThanOrEqualTo(65)
		}
		
		creatorLabel.snp.makeConstraints { make in
			make.leading.trailing.equalTo(self.view).inset(10)
			make.top.equalTo(textView.snp.bottom).offset(10)
		}
		createdAtLabel.snp.makeConstraints { make in
			make.leading.trailing.equalTo(self.view).inset(10)
			make.top.equalTo(creatorLabel.snp.bottom).offset(10)
		}
		
		saveButton.snp.makeConstraints { make in
			make.leading.trailing.equalTo(self.view).inset(10)
			make.top.equalTo(createdAtLabel.snp.bottom).offset(10)
			make.bottom.equalTo(self.view.snp.bottomMargin).inset(10)
			make.height.equalTo(40)
		}
		saveButton.setTitle("Save", for: .normal)
		saveButton.layer.cornerRadius = 5
		saveButton.backgroundColor = .lightGray
		
		textView.layer.cornerRadius = 5
		textView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
		textView.layer.borderWidth = 0.5
		textView.clipsToBounds = true
		textView.isScrollEnabled = false
	
		titleView.borderStyle = .roundedRect
		titleView.layer.cornerRadius = 5
		titleView.layer.borderColor = UIColor.lightGray.cgColor
	}
	
	func setupBindings() {
		viewModel.titleObs
			.take(1)
			.bind(to: titleView.rx.text)
			.disposed(by: disposeBag)
		
		viewModel.createdAtObs
			.take(1)
			.bind(to: createdAtLabel.rx.text)
			.disposed(by: disposeBag)
		
		viewModel.createdByObs
			.take(1)
			.bind(to: creatorLabel.rx.text)
			.disposed(by: disposeBag)
		
		titleView.rx.text
			.filterNil()
			.bind(to: viewModel.titleObs)
			.disposed(by: disposeBag)
		
		viewModel.bodyObs
			.take(1)
			.bind(to: textView.rx.text)
			.disposed(by: disposeBag)
		
		textView.rx.text
			.filterNil()
			.bind(to: viewModel.bodyObs)
			.disposed(by: disposeBag)
		
		saveButton.rx.tap
			.subscribe( onNext: {
				var todo = self.viewModel.todoObs.value
				todo.title = self.viewModel.titleObs.value
				self.viewModel.todoObs.accept(todo)
			})
			.disposed(by: disposeBag)
	}
}
