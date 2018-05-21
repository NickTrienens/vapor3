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

class TableViewDataProvider<Model, Cell: TableCell<Model>>: NSObject, UITableViewDelegate, UITableViewDataSource {

    let disposeBag = DisposeBag()

    var items = Variable<[Model]>([])
    let itemSelected = PublishSubject<Model>()
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

        items.asObservable().subscribe(
            onNext: { _ in
                tableView.reloadData()
        })
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

}
//
//class SectionedTableHeader<T>: UIView {
//    typealias SectionData = T
//    // MARK: - Config -
//    func update(with data: SectionData) { }
//}
//
////class SectionedTableCell<T>: UITableViewCell {
////    typealias Model = T
////    // MARK: - Config -
////    func update(with data: Model) { }
////}
//
//class SectionedTableViewDataProvider< HeaderModel, Model, HeaderViewType: SectionedTableHeader<HeaderModel>, CellType: TableCell<Model> >: NSObject, UITableViewDelegate, UITableViewDataSource {
//    
//    let disposeBag = DisposeBag()
//    
//	let sections = Variable<[SectionData<HeaderModel, Model>]>([])
//    let itemSelected = PublishSubject<Model>()
//    var selectedItems = BehaviorSubject<[Model]>(value: [])
//    
//    let contentOffset = PublishSubject<CGPoint>()
//    var momentarySelection: Bool = true
//    var rowHeight = UITableViewAutomaticDimension
//    var headerHeight: CGFloat = 45.0
//	
//    init(with tableView: UITableView) {
//        super.init()
//        tableView.registerClassForCellReuse(CellType.self)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.rowHeight = rowHeight
//        
//        sections.asObservable()
//            .subscribe(
//                onNext: { sections in
//                    tableView.reloadData()
//                }
//            )
//            .disposed(by: disposeBag)
//    }
//    
//    // MARK: - TableView Delegate & Datasource _
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return sections.value.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return sections.value.elementAt(section)?.items.count ?? 0
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return rowHeight
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: String( describing: CellType.self), for: indexPath)
//        if let cell = cell as? CellType, let data: Model = element(indexPath) {
//            cell.update(with: data)
//        }
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if momentarySelection {
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
//        if let data = element(indexPath) {
//            itemSelected.onNext( data )
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return headerHeight
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = HeaderViewType()
//        if let headerData: HeaderModel = headerData(section) {
//            headerView.update(with: headerData)
//        }
//        return headerView
//    }
//    
//    func element(_ indexPath: IndexPath) -> Model? {
//        return sections.value.elementAt(indexPath.section)?.items.elementAt(indexPath.row)
//    }
//    func headerData(_ section: Int) -> HeaderModel? {
//        return sections.value.elementAt(section)?.headerItem
//    }
//}
