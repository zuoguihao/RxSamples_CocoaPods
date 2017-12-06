//
//  SelectTableViewCell.swift
//  TwoWayBind
//
//  Created by 左得胜 on 2017/12/6.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectTableViewCell: UITableViewCell {

    // MARK: - Property
    static let reuseID = "SelectTableViewCellID"
    /// 左侧指示文案
    @IBOutlet weak var nameLabel: UILabel!
    /// 选择 btn
    @IBOutlet weak var selectBtn: UIButton!
    
    let bag = DisposeBag()
    
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Public Method
    func showData(model: PushSettingModel) {
        nameLabel.text = model.pushType.value.name
    }

}

extension Reactive where Base: SelectTableViewCell {
    var ds_select: ControlProperty<Bool> {
        return base.selectBtn.rx.ds_select
    }
}
