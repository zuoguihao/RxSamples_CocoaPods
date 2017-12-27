//
//  Foldable_SliderTableViewCell.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/27.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift

class Foldable_SliderTableViewCell: UITableViewCell {
    
    static let reuseID = "Foldable_SliderTableViewCellID"
    let bag = DisposeBag()
    
    @IBOutlet weak var mySlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
