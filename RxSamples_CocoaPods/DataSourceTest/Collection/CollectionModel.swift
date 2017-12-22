//
//  CollectionModel.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/22.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import Foundation
import UIKit

struct CollectionModel {
    let logo: UIImage
    let title: String
    let id: Int
    
    init(logo: UIImage, title: String, id: Int) {
        self.logo = logo
        self.title = title
        self.id = id
    }
}
