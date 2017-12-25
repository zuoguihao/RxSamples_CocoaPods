//
//  MultiplyCellTableViewController.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/25.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MultiplyCellTableViewController: UITableViewController {

    // MARK: - Property
    private let bag = DisposeBag()
    
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
}

// MARK: - Private Method
private extension MultiplyCellTableViewController {
    private func setupUI() {
        tableView.delegate = nil
        tableView.dataSource = nil
        
        tableView.backgroundColor = UIColor.groupTableViewBackground
        let footerView = UIView()
        footerView.backgroundColor = tableView.backgroundColor
        footerView.frame.size.height = 8
        tableView.tableFooterView = footerView
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        tableView.rx.enableAutoDeselect().disposed(by: bag)
        tableView.rx.setDelegate(self).disposed(by: bag)
        // group 模式下，tableview 自带35的高度
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, MultiplyCellEnum>>.init(configureCell:  { (_, tableView, indexPath, cellEnum) -> UITableViewCell in
            switch cellEnum {
            case let .image(titles, images):
                let cell = tableView.dequeueReusableCell(withIdentifier: MultiplyCell_ImageTableViewCell.reuseID, for: indexPath) as! MultiplyCell_ImageTableViewCell
                cell.titleLabel.text = titles
                cell.iconIV.image = images
                
                return cell
                
            case let .detail(title, detail):
                let cell = tableView.dequeueReusableCell(withIdentifier: MultiplyCell_DetailTableViewCell.reuseID, for: indexPath) as! MultiplyCell_DetailTableViewCell
                cell.titleLabel.text = title
                cell.detailTitleLabel.text = detail
                
                return cell
            }
            
        })
        
        let dataArr = [
            SectionModel.init(model: "Section 1", items: [
                MultiplyCellEnum.image(title: "修改头像", image: UIImage.init(named: "Jietu20171220")!),
                MultiplyCellEnum.detail(title: "修改昵称", detail: "qtds8810")
            ]),
            SectionModel(model: "Section 2", items: [
                MultiplyCellEnum.detail(title: "性别", detail: "男"),
                MultiplyCellEnum.detail(title: "生日", detail: "点击设置生日"),
                MultiplyCellEnum.detail(title: "星座", detail: "天蝎座")
                ]),
            SectionModel(model: "Section 3", items: [
                MultiplyCellEnum.detail(title: "签名", detail: "点击设置签名")
                ])
            ]
        
        Observable.just(dataArr)
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: bag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { (indexPath) in
                UIAlertController.show(message: "您点击了\(indexPath)")
            })
        .disposed(by: bag)
        
    }
}
