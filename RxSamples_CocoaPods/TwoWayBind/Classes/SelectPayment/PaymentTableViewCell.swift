//
//  PaymentTableViewCell.swift
//  TwoWayBind
//
//  Created by 左得胜 on 2017/12/5.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    // MARK: - Property
    /// 左侧支付 icon
    @IBOutlet weak var iconIV: UIImageView!
    /// 支付名称
    @IBOutlet weak var nameLabel: UILabel!
    /// 选择按钮
    @IBOutlet weak var selectBtn: UIButton!
    
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - Public Method

}
