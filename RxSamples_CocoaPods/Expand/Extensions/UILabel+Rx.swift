//
//  UILabel+Rx.swift
//  TwoWayBind
//
//  Created by 左得胜 on 2017/12/8.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif

extension Reactive where Base: UILabel {
    public var textColor: Binder<UIColor> {
        return Binder.init(self.base, binding: { (label, textColor) in
            label.textColor = textColor
        })
    }
}
