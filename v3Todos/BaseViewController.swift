//
//  BaseViewController.swift
//  v3Todos
//
//  Created by Nicholas Trienens on 5/21/18.
//

import Foundation
import RxSwift

public class BaseViewController: UIViewController{
	let disposeBag = DisposeBag()
	
	public init() {
		super.init(nibName: nil, bundle: nil)
	}
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
