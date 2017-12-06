//
//  PushSettingModel.swift
//  TwoWayBind
//
//  Created by 左得胜 on 2017/12/6.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import Foundation
import RxSwift

enum PushType {
    case confirm
    case willExpire
    case expired
    case refunded
    case getGift
    case couponInfo
    case favorite
    
    var name: String {
        switch self {
        case .confirm:
            return "消费确认"
        case .willExpire:
            return "订单即将过期"
        case .expired:
            return "订单已过期"
        case .refunded:
            return "退款成功"
        case .getGift:
            return "获得礼券"
        case .couponInfo:
            return "优惠信息"
        case .favorite:
            return "喜欢的礼遇有更新"
        }
    }
}

struct PushSettingModel {
    let pushType: Variable<PushType>
    let select: Variable<Bool>
}
