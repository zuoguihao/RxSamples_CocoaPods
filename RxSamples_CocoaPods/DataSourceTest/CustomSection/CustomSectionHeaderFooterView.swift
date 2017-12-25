//
//  CustomSectionHeaderFooterView.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/25.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit

class CustomSectionHeaderFooterView: UITableViewHeaderFooterView {

    // MARK: Property
    static let reuseID = "CustomSectionHeaderFooterViewID"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21)
        return label
    }()
    
    // MARK: - LifeCycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.groupTableViewBackground
        
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
