//
//  ViewController.swift
//  v3 todos
//
//  Created by Nicholas Trienens on 5/15/18.
//

import UIKit
import RxSwift
import SnapKit
import RxCocoa

class TodoViewController: BaseViewController {
	
	let viewModel: TodoViewModel
	let tableView = UITableView()
	
	let todoDataProvider: TableViewDataProvider<Todo, TodoTableViewCell>

	lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action:
			#selector(TodoViewController.handleRefresh(_:)),
								 for: UIControlEvents.valueChanged)
		refreshControl.tintColor = UIColor.red
		
		return refreshControl
	}()
	
	public init(_ client: Client) {
		todoDataProvider = TableViewDataProvider<Todo, TodoTableViewCell>(with: tableView)
		todoDataProvider.rowHeight = 50
		tableView.separatorInset = .zero
		tableView.separatorColor = UIColor.lightGray
		
		viewModel = TodoViewModel(client, deviceName: UIDevice.current.name)
		
		super.init()
		self.title = "Todos"
		
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		let addButton: UIBarButtonItem = UIBarButtonItem( title: "+", style: .plain, target: nil, action: nil)
		self.navigationItem.leftBarButtonItem = addButton
		addButton.rx.tap
			.subscribe( { _ in
				self.viewModel.addTodo()
			})
			.disposed(by: disposeBag)

		let editButton: UIBarButtonItem = UIBarButtonItem( title: "Edit", style: .plain, target: nil, action: nil)
		self.navigationItem.rightBarButtonItem = editButton
		editButton.rx.tap
			.subscribe( { _ in
				self.viewModel.toggleEditting()
			})
			.disposed(by: disposeBag)
		
		addTableView()
		setupBindings()
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func addTableView() {
		view.addSubview(tableView)
		tableView.addSubview(self.refreshControl)

		tableView.snp.makeConstraints { make in
			make.edges.equalTo(self.view)
		}
	}
	func setupBindings() {
		viewModel.items
			.bind(to: todoDataProvider.items)
			.disposed(by: disposeBag)
		
		viewModel.loadingStatus
			.filter { $0.active == false }
			.subscribe( onNext: { _ in
				self.refreshControl.endRefreshing()
			})
			.disposed(by: disposeBag)
		
		viewModel.editting
			.subscribe( onNext: { editting in
				self.tableView.isEditing = editting
			})
			.disposed(by: disposeBag)
	}
	
	@objc func handleRefresh(_ refreshControl: UIRefreshControl) {
		viewModel.loadData()
	}
	
}

/// Providers the UI for the tableview cells
class TodoTableViewCell: TableCell<Todo> {
	override func update(with data: Todo) {
		self.textLabel?.text = data.title
		self.accessoryType = .disclosureIndicator
		self.accessoryView?.tintColor = UIColor.darkGray
	}
}
