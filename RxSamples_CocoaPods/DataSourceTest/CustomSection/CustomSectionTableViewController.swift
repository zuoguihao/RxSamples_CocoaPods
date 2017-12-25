//
//  CustomSectionTableViewController.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/25.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CustomSectionTableViewController: UITableViewController {

    private let bag = DisposeBag()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>.init(configureCell: { (source, tableView, indexPath, str) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSectionCellID", for: indexPath)
        cell.textLabel?.text = str
        return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomSectionHeaderFooterView.reuseID) as! CustomSectionHeaderFooterView
        header.titleLabel.text = dataSource[section].model
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

}

// MARK: - Private Method
private extension CustomSectionTableViewController {
    private func setupUI() {
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.register(CustomSectionHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: CustomSectionHeaderFooterView.reuseID)
        tableView.rx.setDelegate(self).disposed(by: bag)
        
        tableView.backgroundColor = UIColor.groupTableViewBackground
        let footerView = UIView()
        footerView.backgroundColor = tableView.backgroundColor
        footerView.frame.size.height = 8
        tableView.tableFooterView = footerView
        
        tableView.rx.enableAutoDeselect().disposed(by: bag)
        
        let dataArr = Observable.just([
            SectionModel(model: "Section 1", items: ["Item 1", "Item 2", "Item 3"]),
            SectionModel(model: "Section 2", items: ["Item 1", "Item 2"]),
            SectionModel(model: "Section 3", items: ["Item 1", "Item 2", "Item 3", "Item 4"])
            ])
        
        dataArr.bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: bag)
    }
}
