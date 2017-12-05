//
//  ProductTableViewCell.swift
//  TwoWayBind
//
//  Created by 左得胜 on 2017/12/5.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class ProductTableViewCell: UITableViewCell {

    // MARK: - Property
    /// 商品名称
    @IBOutlet weak var nameLabel: UILabel!
    /// 商品单价
    @IBOutlet weak var unitPriceLabel: UILabel!
    /// 减号btn
    @IBOutlet weak var minusButton: UIButton! {
        didSet {
            minusButton.isEnabled = count > 0
        }
    }
    /// 数量 label
    @IBOutlet weak var countLabel: UILabel!
    /// 加号 btn
    @IBOutlet weak var plusButton: UIButton!
    
    /// 数据改变闭包
    private var countChangeClosure: ((Int) -> Void)?
    /// 计算属性，计算 cell 的数据变动
    private var rx_count: ControlProperty<Int> {
        let source = Observable<Int>.create { [weak self] (observer) in
            self?.countChangeClosure = observer.onNext
            
            return Disposables.create()
        }
        .distinctUntilChanged()
        
        let sink = Binder(self) { (cell, count) in
            cell.count = count
        }
        .asObserver()
        
        return ControlProperty(values: source, valueSink: sink)
    }
    
    private var count: Int = 0 {
        didSet {
            if count < 0 {
                count = 0
                return
            }
            
            minusButton.isEnabled = count > 0
            plusButton.isEnabled = count <= 9
            countLabel.text = String(count)
        }
    }
    
    private let bag = DisposeBag()
    
    private typealias MyAction = (_ lhs: inout Int, _ rhs: Int) -> Void
    private func changeCount(_ action: MyAction) {
        action(&count, 1)
        countChangeClosure?(count)
    }
        
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Public Method
    func showData(model: ProductInfoModel, indexPath: IndexPath) {
        nameLabel.text = model.name
        unitPriceLabel.text = "单价：\(model.unitPrice)元"
        
        (rx_count <-> model.count).disposed(by: bag)
        
        backgroundColor = indexPath.row % 2 == 0 ? UIColor.random : UIColor.white
    }
    
    // MARK: - Action
    /// 减号按钮点击
    @IBAction func minusBtnAction() {
        changeCount(-=)
    }
    
    /// 加号按钮点击
    @IBAction func plusBtnAction() {
        changeCount(+=)
    }
    
}
