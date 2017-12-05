//
//  ProductInfoModel.swift
//  TwoWayBind
//
//  Created by 左得胜 on 2017/12/5.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import Foundation
import RxSwift

struct ProductInfoModel {
    let id: Int
    let name: String
    let unitPrice: Int
    let count: Variable<Int>
}

