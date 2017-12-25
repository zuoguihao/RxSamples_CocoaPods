//
//  CustomCellTableViewCell.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/25.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
