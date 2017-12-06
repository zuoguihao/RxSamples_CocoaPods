//
//  PushSettingViewController.swift
//  TwoWayBind
//
//  Created by 左得胜 on 2017/12/6.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class PushSettingViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var baseTableView: UITableView! {
        didSet {
            baseTableView.rx.enableAutoDeselect().disposed(by: bag)
            baseTableView.register(SelectTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: SelectTableViewHeaderFooterView.reuseID)
            baseTableView.rx.setDelegate(self).disposed(by: bag)
        }
    }
    
    let bag = DisposeBag()
    private typealias mySectionModel = SectionModel<String, PushSettingModel>
    /// 数据源
    private let dataSource = RxTableViewSectionedReloadDataSource<mySectionModel> (configureCell: { (model, tableView, indexPath, value) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectTableViewCell.reuseID, for: indexPath) as! SelectTableViewCell
        
        cell.showData(model: value)
        
        (cell.rx.ds_select <-> value.select).disposed(by: cell.bag)
        
        return cell
    })
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Public Method
    
    // MARK: - Action
    

}

// MARK: - Private Method
private extension PushSettingViewController {
    private func setupUI() {
        let dataSource = self.dataSource
        
        let pushElement: [mySectionModel] = {
            let consItems = [
                PushSettingModel(pushType: Variable(.confirm), select: Variable(true)),
                PushSettingModel(pushType: Variable(.willExpire), select: Variable(false)),
                PushSettingModel(pushType: Variable(.expired), select: Variable(false)),
                PushSettingModel(pushType: Variable(.refunded), select: Variable(false))
            ]
            let consSection = mySectionModel(model: "消费相关", items: consItems)
            
            let otherItems = [
                PushSettingModel(pushType: Variable(.getGift), select: Variable(false)),
                PushSettingModel(pushType: Variable(.couponInfo), select: Variable(false)),
                PushSettingModel(pushType: Variable(.favorite), select: Variable(false)),
            ]
            let otherSection = mySectionModel(model: "其它", items: otherItems)
            
            return [consSection, otherSection]
        }()
        
        
        Observable.just(pushElement)
        .bind(to: baseTableView.rx.items(dataSource: dataSource))
        .disposed(by: bag)
        
        // 将选中 cell 绑定到 cell 右侧的选中状态上去
        baseTableView.rx
            .itemSelected
            .map({ (indexPath) in
                return dataSource[indexPath]
            })
            .subscribe(onNext: { [unowned self] (model) in
                
                model.pushType.asObservable()
                    .map({ (pushType) in
                        return !model.select.value
                    })
                    .bind(to: model.select)
                    .disposed(by: self.bag)
                
            })
        .disposed(by: bag)
        
    }
}

// MARK: - UITableViewDelegate
extension PushSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SelectTableViewHeaderFooterView.reuseID) as! SelectTableViewHeaderFooterView
        
        header.nameLabel.text = dataSource[section].model
        
        let selectItems = dataSource[section].items.map {$0.select}
        Observable.combineLatest(selectItems.map { $0.asObservable() }) {
            $0.contains(true)
        }
        .bind(to: header.selectSwitch.rx.isOn)
        .disposed(by: header.bag)
        
        header.selectSwitch.rx.isOn
            .subscribe(onNext: { (isSelectedAll) in
                selectItems.forEach { $0.value = isSelectedAll }
            })
        .disposed(by: header.bag)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}
