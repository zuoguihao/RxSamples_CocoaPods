//
//  ShipmentDealViewController.swift
//  TwoWayBind
//
//  Created by 左得胜 on 2017/12/5.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class ShipmentDealViewController: UIViewController {

    // MARK: - Property
    let bag = DisposeBag()
    
    /// 表格
    @IBOutlet weak var baseTableView: UITableView! {
        didSet {
            baseTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
            baseTableView.scrollIndicatorInsets = baseTableView.contentInset
            baseTableView.rx.enableAutoDeselect().disposed(by: bag)
            
        }
    }
    /// 总价
    @IBOutlet weak var totalPriceLabel: UILabel!
    /// 购买按钮
    @IBOutlet weak var purchaseBtn: UIButton!
    
    private let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ProductInfoModel>>(configureCell: {(_, tableView, indexPath, model) in
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCellID", for: indexPath) as! ProductTableViewCell
        
        cell.showData(model: model, indexPath: indexPath)
        
        return cell
    })
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
}

// MARK: - Private Method
private extension ShipmentDealViewController {
    private func setupUI() {
        let products = [1, 2, 3, 4, 6, 8, 10, 12]
        .map{ ProductInfoModel(id: 1000 + $0, name: "商品:\($0)", unitPrice: $0 * 100, count: Variable(0)) }
        
        let items = Observable.just([SectionModel(model: "", items: products)])
            .share(replay: 1)
        
        items
        .bind(to: baseTableView.rx.items(dataSource: dataSource))
        .disposed(by: bag)
        
        let totalPrice = items
            .map { $0.flatMap { $0.items } }
            .flatMap { $0.reduce(.just(0), { (result, model) in
                Observable.combineLatest(result, model.count.asObservable().map {model.unitPrice * $0}, resultSelector: +)
            }) }
        .share(replay: 1)
        
        totalPrice
            .map { "总价：\($0)元" }
        .bind(to: totalPriceLabel.rx.text)
        .disposed(by: bag)
        
        totalPrice
            .map { $0 != 0 }
        .bind(to: purchaseBtn.rx.isEnabled)
        .disposed(by: bag)
    }
}
