//
//  HomeItemModel.swift
//  Stopwatch
//
//  Created by 左得胜 on 2017/12/7.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import Foundation
import RxSwift

protocol StopwatchViewModelProtocol {
    /// 停止 style
    var startAStopStyle: Observable<DSStyle.Button> { get }
    ///  重置 style
    var resetALapStyle: Observable<DSStyle.Button> { get }
    /// 展示时间
    var displayTime: Observable<String> { get }
    /// 展示元素
    var displayElements: Observable<[(title: Observable<String>, displayTime: Observable<String>, color: Observable<UIColor>)]> { get }
    
    init(input: (startAStopTrigger: Observable<Void>, resetALapTrigger: Observable<Void>))
}

struct HomeItemModel {
    let title: String
    let type: StopwatchViewModelProtocol.Type
    
    init(title: String, type: StopwatchViewModelProtocol.Type) {
        self.title = title
        self.type = type
    }
}
