//
//  IconCollectionViewCell.swift
//  RxDataSourcesPractice
//
//  Created by 左得胜 on 2017/12/20.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class IconCollectionViewCell: UICollectionViewCell {
    
    /// icon
    @IBOutlet weak var iconImageView: UIImageView!
//    {
//        didSet {
//            iconImageView.layer.contents = 8
//            iconImageView.layer.masksToBounds = true
//        }
//    }
    /// 文字
    @IBOutlet weak var titleLabel: UILabel!
    /// 删除 btn
    @IBOutlet weak var deleteBtn: UIButton!
    
    let bag = DisposeBag()
    /*
    var isEditting: Variable<Bool> = Variable(false) {
        didSet {
            switch isEditting.value {
            case true:
                print(true)
                deleteBtn.isHidden = false
            case false:
                print(false)
                deleteBtn.isHidden = true
            }
        }
    }
    */
    var isEditting: Bool = false {
        didSet {
            switch isEditting {
            case true:
//                print(true)
                deleteBtn.isHidden = false
            case false:
//                print(false)
                deleteBtn.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}

extension Reactive where Base: IconCollectionViewCell {
    var isEditting: Binder<Bool> {
        return Binder.init(base, binding: { (cell, isEdit) in
            cell.isEditting = isEdit
        })
    }
}


