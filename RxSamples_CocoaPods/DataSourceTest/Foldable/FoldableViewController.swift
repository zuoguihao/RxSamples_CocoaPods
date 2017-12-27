//
//  FoldableViewController.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/26.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class FoldableViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var myTableView: UITableView!
    
    private let bag = DisposeBag()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

// MARK: - Private Method
private extension FoldableViewController {
    private func setupUI() {
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.estimatedRowHeight = 50
        myTableView.backgroundColor = UIColor.groupTableViewBackground
        let footerView = UIView()
        footerView.backgroundColor = myTableView.backgroundColor
        footerView.frame.size.height = 8
        myTableView.tableFooterView = footerView
        
        myTableView.rx.enableAutoDeselect().disposed(by: bag)
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<FoldableEnum, FoldableModel>>(configureCell: { (dataSource, tableView, indexPath, item) in
            switch item.type {
            case let .display(title, type, _):
                let cell = tableView.dequeueReusableCell(withIdentifier: "Foldable_NormalCellID", for: indexPath)
                cell.detailTextLabel?.text = type.subTitle
                if let label = cell.textLabel {
                    title.asObservable().bind(to: label.rx.text)
                    .disposed(by: self.bag)
                }
                
                return cell
            case let .input(input):
//                return UITableViewCell()
                switch input {
                    
                case let .textField(text, placeHolder):
                    let cell = tableView.dequeueReusableCell(withIdentifier: Foldable_FieldTableViewCell.reuseID, for: indexPath) as! Foldable_FieldTableViewCell
                    cell.nameField.placeholder = placeHolder
                    
                    (cell.nameField.rx.textInput <-> text).disposed(by: cell.bag)
                    
                    return cell
                case let .datePick(date):
                    let cell = tableView.dequeueReusableCell(withIdentifier: Foldable_DatePickerTableViewCell.reuseID, for: indexPath) as! Foldable_DatePickerTableViewCell
                    (cell.datePicker.rx.date <-> date).disposed(by: cell.bag)
                    
                    return cell
                case .status(let title, let isOn):
                    let cell = tableView.dequeueReusableCell(withIdentifier: Foldable_SwitchTableViewCell.reuseID, for: indexPath) as! Foldable_SwitchTableViewCell
                    cell.titleLabel.text = title
                    
                    (cell.mySwitch.rx.isOn <-> isOn).disposed(by: cell.bag)
                    
                    return cell
                case let .title(title, _):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Foldable_TitleTableViewCellID", for: indexPath)
                    cell.textLabel?.text = title
                    
                    return cell
                case let .level(level):
                    let cell = tableView.dequeueReusableCell(withIdentifier: Foldable_SliderTableViewCell.reuseID, for: indexPath) as! Foldable_SliderTableViewCell
                    (cell.mySlider.rx.value <-> level).disposed(by: cell.bag)
                    
                    return cell
                }
            }
        })
        
        dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .automatic, reloadAnimation: .automatic, deleteAnimation: .fade)
        
        dataSource.titleForHeaderInSection = { (dataSource, section) in
            return dataSource[section].model.rawValue
        }
        
        // 数据填充
        // section 1
        let fullName = FoldableModel(defaultTitle: "Qtds 8810", displayType: .fullName)
        let dateOfBirth = FoldableModel(defaultTitle: "2017年12月26日", displayType: .dateOfBirth)
        let maritalStatus = FoldableModel(defaultTitle: "单身", displayType: .maritalStatus)
        
        // section 2
        let favoriteSport = FoldableModel(defaultTitle: "Football", displayType: .favoriteSport)
        let favoriteColor = FoldableModel(defaultTitle: "Green", displayType: .favoriteColor)
        
        // section 3
        let level = FoldableModel(defaultTitle: "3年", displayType: .level)
        
        
        let section1Items = Observable.combineLatest(fullName.allItems, dateOfBirth.allItems, maritalStatus.allItems) { $0 + $1 + $2 }
        let section2Items = Observable.combineLatest(favoriteSport.allItems, favoriteColor.allItems, resultSelector: +)
        let section3Items = level.allItems
        
        
        let section1 = section1Items.map { AnimatableSectionModel.init(model: FoldableEnum.personal, items: $0) }
        let section2 = section2Items.map { AnimatableSectionModel.init(model: FoldableEnum.preferences, items: $0) }
        let section3 = section3Items.map { AnimatableSectionModel.init(model: FoldableEnum.workExperience, items: $0) }
        
        
        // 选中 cell 后
        myTableView.rx.modelSelected(FoldableModel.self)
            .subscribe(onNext: { (model) in
                switch model.type {
                    
                case let .display(_, _, isFolded):
                    isFolded.value = !isFolded.value
                case let .input(input):
                    switch input {
                    case let .title(title, favorite):
                        favorite.value = title
                        
                    default:
                        break
                    }
                }
            })
        .disposed(by: bag)
        
        Observable.combineLatest(section1, section2, section3) { [$0, $1, $2] }
            .bind(to: myTableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
    }
}
