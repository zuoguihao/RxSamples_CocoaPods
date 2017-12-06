//
//  SelectTableViewHeaderFooterView.swift
//  TwoWayBind
//
//  Created by 左得胜 on 2017/12/6.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class SelectTableViewHeaderFooterView: UITableViewHeaderFooterView {

    // MARK: - Property
    /// 重用 id
    static let reuseID = "SelectTableViewHeaderFooterViewID"
    let bag = DisposeBag()
    

    lazy var selectSwitch: UISwitch = UISwitch()
    lazy var nameLabel: UILabel = UILabel()
    
    // MARK: - LifeCycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(selectSwitch)
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(self.contentView)
        }
        selectSwitch.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-15)
            make.centerY.equalTo(self.contentView)
        }
    }
    
}
