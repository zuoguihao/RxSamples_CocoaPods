//
//  UIControl+Rx.swift
//  RxSamples_CocoaPods
//
//  Created by 左得胜 on 2017/12/5.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UIControl {
    public var isEnabled: Binder<Bool> {
        return Binder(self.base) { control, value in
            control.isEnabled = value
        }
    }
}
