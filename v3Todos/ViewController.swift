//
//  ViewController.swift
//  v3 todos
//
//  Created by Nicholas Trienens on 5/15/18.
//

import UIKit
import RxSwift
import SnapKit

class ViewController: UIViewController {
	let client = Client()
	let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		client.getTodos()
			.subscribe(
				onSuccess: { todos in
					print(todos)
				},
				onError: { err in
					print(err)
				}
			)
			.disposed(by: disposeBag)
		
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}
