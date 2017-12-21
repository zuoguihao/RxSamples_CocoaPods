//
//  MBProgressHUD+DS.swift
//  RxDataSourcesPractice
//
//  Created by 左得胜 on 2017/12/21.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import Foundation
import MBProgressHUD

class DSProgressHUD {
    private init() {}
    
    static func showMessage(title: String?, message: String?, offsetY: CGFloat = MBProgressMaxOffset, afterDelay: TimeInterval = 1) {
        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        
        hud.mode = MBProgressHUDMode.text
        hud.label.text = title
        hud.detailsLabel.text = message
        hud.offset.y = offsetY
        hud.removeFromSuperViewOnHide = true
        hud.isUserInteractionEnabled = false
        
        hud.hide(animated: true, afterDelay: afterDelay)
    }
    
}
