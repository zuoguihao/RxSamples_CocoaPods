//
//  MultiplyCellTableViewCell.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/25.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit

class MultiplyCell_ImageTableViewCell: UITableViewCell {

    static let reuseID = "MultiplyCell_ImageTableViewCellID"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconIV: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class MultiplyCell_DetailTableViewCell: UITableViewCell {
    
    static let reuseID = "MultiplyCell_DetailTableViewCellID"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


