//
//  HomeTableViewController.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/22.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.groupTableViewBackground
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 8))
        footerView.backgroundColor = tableView.backgroundColor
        tableView.tableFooterView = footerView
    }
    
}
