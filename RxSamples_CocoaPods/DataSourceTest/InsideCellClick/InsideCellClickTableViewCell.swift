//
//  InsideCellClickTableViewCell.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/25.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InsideCellClickTableViewCell: UITableViewCell {

    static let reuseID = "InsideCellClickTableViewCellID"
    let bag = DisposeBag()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailBtn: UIButton! {
        didSet {
            detailBtn.setBackgroundImage(UIImage.image(with: UIColor.cyan), for: .normal)
            detailBtn.setBackgroundImage(UIImage.image(with: UIColor.green), for: .highlighted)
            detailBtn.layer.cornerRadius = 8
            detailBtn.layer.masksToBounds = true
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
