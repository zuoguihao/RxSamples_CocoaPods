//
//  CustomCellTableViewController.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/25.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CustomCellTableViewController: UITableViewController {

    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

// MARK: - Private Method
private extension CustomCellTableViewController {
    private func setupUI() {
        tableView.dataSource = nil
        tableView.delegate = nil
        
        let footerView = UIView()
        footerView.backgroundColor = tableView.backgroundColor
        footerView.frame.size.height = 8
        tableView.tableFooterView = footerView
        
        let items = Observable.just([
            CustomCellModel(title: "选项一", isOn:  true),
            CustomCellModel(title: "选项二", isOn:  false),
            CustomCellModel(title: "选项三", isOn:  false)
            ])
        
        items.bind(to: tableView.rx.items(cellIdentifier: "CustomCellTableViewCellID", cellType: CustomCellTableViewCell.self)) { (row, element, cell) in
            cell.nameLabel.text = element.title
            cell.mySwitch.isOn = element.isOn
        }
        .disposed(by: bag)
    }
}
