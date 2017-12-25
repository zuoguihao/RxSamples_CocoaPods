//
//  InsideCellClickTableViewController.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/25.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SafariServices

class InsideCellClickTableViewController: UITableViewController {

    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

// MARK: - Private Method
private extension InsideCellClickTableViewController {
    private func setupUI() {
        tableView.dataSource = nil
        tableView.delegate = nil
        
        tableView.backgroundColor = UIColor.groupTableViewBackground
        let footerView = UIView()
        footerView.backgroundColor = tableView.backgroundColor
        footerView.frame.size.height = 8
        tableView.tableFooterView = footerView
        
//        tableView.rx.enableAutoDeselect().disposed(by: bag)
        
        let dataArr = [
            InsideCellClickModel(name: "百度首页", url: URL(string: "https://www.baidu.com")!),
            InsideCellClickModel(name: "GitHub首页", url: URL(string: "https://github.com/qtds8810/")!),
        ]
        
        Observable.just(dataArr)
            .bind(to: tableView.rx.items(cellIdentifier: InsideCellClickTableViewCell.reuseID, cellType: InsideCellClickTableViewCell.self)) { [unowned self] (row, element, cell) in
                cell.titleLabel.text = element.name
                
                cell.detailBtn.rx.tap
                    .map { element.url }
                    .subscribe(onNext: { (url) in
                        let safari = SFSafariViewController(url: url)
                        if #available(iOS 10, *) {
                            safari.preferredBarTintColor = UIColor.green
                        }
                        self.showDetailViewController(safari, sender: nil)
                        
                    })
                .disposed(by: cell.bag)
        }
        .disposed(by: bag)
        
    }
}
