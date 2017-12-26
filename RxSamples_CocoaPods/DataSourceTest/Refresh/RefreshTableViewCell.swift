//
//  RefreshTableViewCell.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/26.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit

class RefreshTableViewCell: UITableViewCell {

    static let reuseID = "RefreshTableViewCellID"
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
