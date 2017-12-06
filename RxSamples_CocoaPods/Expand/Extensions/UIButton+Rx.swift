//
//  UIButton+Rx.swift
//  TwoWayBind
//
//  Created by 左得胜 on 2017/12/6.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    var ds_select: ControlProperty<Bool> {
        let source = tap.map { [unowned button = self.base] (_) -> Bool in
            button.isSelected = !button.isSelected
            
            return button.isSelected
        }
        
        return ControlProperty(values: source, valueSink: isSelected)
    }
}
