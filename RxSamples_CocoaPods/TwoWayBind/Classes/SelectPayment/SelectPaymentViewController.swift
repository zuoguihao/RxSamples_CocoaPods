//
//  SelectPaymentViewController.swift
//  TwoWayBind
//
//  Created by 左得胜 on 2017/12/5.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SelectPaymentViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var baseTableView: UITableView! {
        didSet {
            baseTableView.rx.enableAutoDeselect().disposed(by: bag)
        }
    }
    private typealias mySectionModel = SectionModel<PaymentModel, PaymentEnum>
    /// 数据源
    private let dataSource = RxTableViewSectionedReloadDataSource<mySectionModel>(configureCell: { (model, tableView, indexPath, paymentEnum) in
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCellID", for: indexPath) as! PaymentTableViewCell
        
        return cell
    })
    
    let bag = DisposeBag()
    
    
    // MAKR: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
}

// MARK: - Private Method
private extension SelectPaymentViewController {
    private func setupUI() {
        let model = PaymentModel(defaultSelectedType: .aliPay)
        
        baseTableView.rx.modelSelected(PaymentEnum.self)
        .bind(to: model.selectedType)
        .disposed(by: bag)
        
        let paymentSection = mySectionModel(model: model, items: [.aliPay, .applePay, .unionPay, .weChat])
        
        
        Observable.just([paymentSection])
        .bind(to: baseTableView.rx.items(dataSource: dataSource))
        .disposed(by: bag)
    }
}
