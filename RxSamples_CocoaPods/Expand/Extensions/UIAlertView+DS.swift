//
//  UIAlertView+DS.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/25.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit

extension UIAlertController {
    class func show(title: String? = nil, message: String?, preferredStyle: UIAlertControllerStyle = .alert, confirm: String? = "确定", confirmHandler: ((UIAlertAction) -> Void)? = nil, cancel: String? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        if confirm != nil {
            alertVC.addAction(UIAlertAction(title: confirm, style: .default, handler: confirmHandler))
        }
        if cancel != nil {
            alertVC.addAction(UIAlertAction(title: cancel, style: .cancel, handler: cancelHandler))
        }
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: true, completion: nil)
        
    }
}
