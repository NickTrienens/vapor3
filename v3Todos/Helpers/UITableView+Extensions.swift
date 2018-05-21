//
//  UITableView+Extensions.swift
//  FuzzKit
//
//  Created by Nicholas Trienens on 11/06/17.
//  Copyright © 2017 Fuzz Productions, LLC. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension UITableView {
    /// Register a UITableViewCell for reuse with the class name as the reuse identifier
    ///
    /// - Parameter _: The class to be registered
    func registerClassForCellReuse<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }

    /// Dequeue a reusable cell with the class name as the reuse identifier
    ///
    /// - Parameter indexPath: The `indexPath` to dequeue the cell for
    /// - Returns: The dequeued cell
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(String(describing: T.self))")
        }

        return cell
    }

    /// Hide the cells not returned from the UITableViewDataSource.
    func hideTrailingCells() {
        tableFooterView = UIView()
    }
}

extension Reactive where Base: UITableView {
	func selectedModels<T: Equatable>(_ modelType: T.Type) -> ControlEvent<[T]> {
		let selected = base.rx.modelSelected(T.self).distinctUntilChanged().scan([]) { $0 + [$1] }
		let deselected = base.rx.modelDeselected(T.self).scan([]) { $0 + [$1] }.startWith([])
		
		let source = Observable.combineLatest(selected, deselected) { (selected, deselected) -> [T] in
			var cpy = selected
			deselected.forEach { cpy.remove(from: $0) }
			return cpy
		}
		
		return ControlEvent(events: source)
	}
}
