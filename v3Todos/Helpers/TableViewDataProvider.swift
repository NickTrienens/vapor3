//
//  TableViewDataProvider.swift
//  FuzzKit
//
//  Created by Nicholas Trienens on 11/06/17.
//  Copyright © 2017 Fuzz Productions, LLC. All rights reserved.
//

import UIKit
import RxSwift

class TableCell<T>: UITableViewCell {
    typealias Model = T
    // MARK: - Config -
    func update(with data: Model) { }
}

enum UpdateAction: Int {
	case delete
	case reorder
}

class TableViewDataProvider<Model, Cell: TableCell<Model>>: NSObject, UITableViewDelegate, UITableViewDataSource {

    let disposeBag = DisposeBag()

    var items = Variable<[Model]>([])
    let itemSelected = PublishSubject<Model>()
	let itemsUpdated = PublishSubject<(UpdateAction, [Model])>()

    var selectedItems = Variable<[Model]>([])

    let contentOffset = PublishSubject<CGPoint>()
    var momentarySelection: Bool = true
    var rowHeight = UITableViewAutomaticDimension

    init(with tableView: UITableView) {
        super.init()
        tableView.registerClassForCellReuse(Cell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = rowHeight

        items.asObservable()
			.subscribe(
            	onNext: { _ in
                	tableView.reloadData()
        		}
			)
            .disposed(by: disposeBag)
    }

    // MARK: - TableView Delegate & Datasource _
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.value.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String( describing: Cell.self), for: indexPath)
        if let cell = cell as? Cell, let data: Model = items.value.elementAt(indexPath.row) {
            cell.update(with: data)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if momentarySelection {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        if let data = items.value.elementAt(indexPath.row) {
            itemSelected.onNext( data)
        }
    }

	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
		return .delete
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if let deleted = items.value.elementAt(indexPath.row) {
			self.itemsUpdated.onNext( (.delete, [deleted]) )
		}
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, moveRowAt indexPath: IndexPath, to: IndexPath) -> Void {
		var reordered = self.items.value
		
		if let swap1 = reordered.elementAt(indexPath.row), let swap2 = reordered.elementAt(to.row) {
			reordered.replace(index: indexPath.row, with: swap2)
			reordered.replace(index: to.row, with: swap1)
		}
		self.itemsUpdated.onNext( (.reorder, reordered ))
	}
	
	func element(_ indexPath: IndexPath) -> Model? {
       return items.value.elementAt(indexPath.row)
	}
}

