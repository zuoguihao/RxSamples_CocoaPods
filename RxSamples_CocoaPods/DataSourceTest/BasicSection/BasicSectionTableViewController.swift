//
//  BasicSectionTableViewController.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/25.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class BasicSectionTableViewController: UITableViewController {

    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

// MARK: - Private Method
private extension BasicSectionTableViewController {
    private func setupUI() {
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.backgroundColor = UIColor.groupTableViewBackground
        
        let footerView = UIView()
        footerView.backgroundColor = tableView.backgroundColor
        footerView.frame.size.height = 8
        tableView.tableFooterView = footerView
        
        tableView.rx.enableAutoDeselect().disposed(by: bag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>.init(configureCell: { (datasource, tv, indexPath, str) in
            let cell = tv.dequeueReusableCell(withIdentifier: "BasicSectionCellID", for: indexPath)
            cell.textLabel?.text = str
            return cell
        })
        
        dataSource.titleForHeaderInSection = { (dataSource, section) in
            return dataSource[section].model
        }
        
        let dataArr = Observable.just([
            SectionModel(model: "Section 1", items: ["Item 1", "Item 2", "Item 3"]),
            SectionModel(model: "Section 2", items: ["Item 1", "Item 2"]),
            SectionModel(model: "Section 3", items: ["Item 1", "Item 2", "Item 3", "Item 4"])
            ])
        dataArr.bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: bag)
    }
}
