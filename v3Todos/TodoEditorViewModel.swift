//
//  TodoEditorViewModel.swift
//  v3Todos
//
//  Created by Nicholas Trienens on 5/22/18.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxFuzz

class TodoEditorViewModel {
	let disposeBag = DisposeBag()
	
	let todoObs: BehaviorRelay<Todo>
	
	let titleObs = BehaviorRelay<String>(value: "")
	let bodyObs = BehaviorRelay<String>(value: "")
	let createdAtObs = BehaviorRelay<String>(value: "")
	let createdByObs = BehaviorRelay<String>(value: "")
	
	init(todo: BehaviorRelay<Todo>) {
		todoObs = todo
		setupBindings()
	}
	func setupBindings() {
		todoObs.map { $0.title }
			.bind(to: titleObs)
			.disposed(by: disposeBag)
		
		todoObs.map { $0.creator }
			.bind(to: createdByObs)
			.disposed(by: disposeBag)
		
		todoObs.map { $0.createdAt.debugDescription }
			.bind(to: createdAtObs)
			.disposed(by: disposeBag)	
	}
}
