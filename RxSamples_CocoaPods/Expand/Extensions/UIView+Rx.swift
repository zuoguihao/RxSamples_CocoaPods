//
//  UIView+Rx.swift
//  RxSamples_CocoaPods
//
//  Created by 左得胜 on 2017/12/5.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    public var isHidden: Binder<Bool> {
        return Binder(self.base) { (view, isHidden) in
            view.isHidden = isHidden
        }
    }
}

