//
//  DSTool.swift
//  Stopwatch
//
//  Created by 左得胜 on 2017/12/7.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct DSStyle {
    struct Button {
        let title: String
        let titleColor: UIColor
        let isEnabled: Bool
        let backgroundImage: UIImage?
    }
}

struct DSTool {
    static let form = DateFormatter()
    
    static let convertToTimeInfo: (TimeInterval) -> String = { ms in
        
        form.dateFormat = "mm:ss.SS"
        let date = Date(timeIntervalSince1970: ms)
        
        return form.string(from: date)
    }
}

//struct DSColor {
//    static let
//}

extension Reactive where Base: UIButton {
    var style: AnyObserver<DSStyle.Button> {
        return Binder(base, binding: { (btn, style) in
            btn.setTitle(style.title, for: .normal)
            btn.setTitleColor(style.titleColor, for: .normal)
            btn.isEnabled = style.isEnabled
            btn.setBackgroundImage(style.backgroundImage, for: .normal)
        }).asObserver()
    }
}
