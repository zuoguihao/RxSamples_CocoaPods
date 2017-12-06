//
//  AutoDeselect+Rx.swift
//  TwoWayBind
//
//  Created by 左得胜 on 2017/12/5.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift

extension Reactive where Base: UITableView {
    /// 扩展 UITableView 的选择动画
    public func enableAutoDeselect() -> Disposable {
        return itemSelected
            .map { (at: $0, animated: true) }
        .subscribe(onNext: base.deselectRow)
    }
}

extension Reactive where Base: UICollectionView {
    /// 扩展 UICollectionView 的选择动画
    public func enableAutoDeselect() -> Disposable {
        return itemSelected
            .map { (at: $0, animated: true) }
            .subscribe(onNext: base.deselectItem)
    }
}
