//
//  PaymentModel.swift
//  TwoWayBind
//
//  Created by 左得胜 on 2017/12/5.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import Foundation
import RxSwift

struct PaymentModel {
    let selectedType: Variable<PaymentEnum>
    
    init(defaultSelectedType: PaymentEnum) {
        selectedType = Variable(defaultSelectedType)
    }
}

enum PaymentEnum {
    /// 支付宝
    case aliPay
    /// 微信
    case weChat
    /// 银联
    case unionPay
    /// 苹果支付
    case applePay
    
    /// 根据支付方式返回对应的 icon
    var icon: UIImage? {
        switch self {
        case .aliPay:
            return #imageLiteral(resourceName: "purchase_icon_alipay")
        case .weChat:
            return #imageLiteral(resourceName: "purchase_icon_wechat")
        case .unionPay:
            return #imageLiteral(resourceName: "purchase_icon_unionpay")
        case .applePay:
            return #imageLiteral(resourceName: "purchase_icon_applepay")
        }
    }
    
    ///  根据支付方式返回对应的文案
    var name: String {
        switch self {
        case .aliPay:
            return "支付宝支付"
        case .weChat:
            return "微信支付"
        case .unionPay:
            return "银联支付"
        case .applePay:
            return "Apple Pay"
        }
    }
}
