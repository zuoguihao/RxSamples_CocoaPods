//
//  IconCollectionViewCell.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/22.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class IconCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconIV: UIImageView! {
        didSet {
            iconIV.layer.cornerRadius = 8
            iconIV.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var bag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = DisposeBag()
    }
    
//    var isEditting: Variable<Bool> = Variable<false> {
//        didSet {
//            switch isEditting.value {
//            case true:
//                deleteBtn.isHidden = false
//            case false:
//                deleteBtn.isHidden = true
//            }
//        }
//    }
    
    var isEditting: Bool = false {
        didSet {
            switch isEditting {
            case true:
                deleteBtn.isHidden = false
                startWigging()
            case false:
                deleteBtn.isHidden = true
                stopWigging()
            }
        }
    }
    
    // MARK: - Private Method
    private func startWigging() {
        guard contentView.layer.animation(forKey: "wiggle") == nil else { return }
        guard contentView.layer.animation(forKey: "bounce") == nil else { return }
        
        let angle = 0.03
        
        let wiggle = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        wiggle.values = [-angle, angle]
        
        wiggle.autoreverses = true
        wiggle.duration = random(interval: 0.1, variance: 0.025)
        wiggle.repeatCount = Float.infinity
        
        contentView.layer.add(wiggle, forKey: "wiggle")
        
        let bounce = CAKeyframeAnimation(keyPath: "transform.translation.y")
        bounce.values = [4.0, 0.0]
        
        bounce.autoreverses = true
        bounce.duration = random(interval: 0.12, variance: 0.025)
        bounce.repeatCount = Float.infinity
        
        contentView.layer.add(bounce, forKey: "bounce")
    }
    
    private func stopWigging() {
        contentView.layer.removeAllAnimations()
    }
    
    private func random(interval: TimeInterval, variance: Double) -> TimeInterval {
        return interval + variance * Double((Double(arc4random_uniform(1000)) - 500.0) / 500.0)
    }
    
}

extension Reactive where Base: IconCollectionViewCell {
    var isEditting: Binder<Bool> {
        return Binder.init(base, binding: { (cell, isEdit) in
            cell.isEditting = isEdit
        })
    }
}
