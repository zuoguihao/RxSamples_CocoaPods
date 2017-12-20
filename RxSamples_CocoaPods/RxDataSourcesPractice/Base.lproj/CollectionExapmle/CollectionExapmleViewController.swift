//
//  CollectionExapmleViewController.swift
//  RxDataSourcesPractice
//
//  Created by 左得胜 on 2017/12/15.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CollectionExapmleViewController: UIViewController {

    // Property
    @IBOutlet private weak var myCollectionView: UICollectionView!
    /// 编辑 item
    @IBOutlet private weak var editItem: UIBarButtonItem!
    
    /// 导航栏 title 枚举
    private enum ItemState {
        case editting
        case viewing
        
        var barTitle: String {
            switch self {
            case .editting:
                return "Done"
            case .viewing:
                return "Edit"
            }
        }
        
        var reversedValue: ItemState {
            switch self {
            case .editting:
                return .viewing
            case .viewing:
                return .editting
            }
        }
        
        var isEditting: Bool {
            switch self {
            case .editting:
                return true
            case .viewing:
                return false
            }
        }
    }
    
    private let rightItemState = Variable(ItemState.viewing)
    private let bag = DisposeBag()
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, CollectionModel>>(configureCell: { (dataSource, collectionView, indexPath, item) in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCellID", for: indexPath)
        
        return cell
    })
    
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    

}

// MARK: - Private Method
private extension CollectionExapmleViewController {
    private func setupUI() {
        rightItemState.asObservable()
            .map { $0.barTitle }
        .bind(to: editItem.rx.title)
        .disposed(by: bag)
        
//        let editItem = UIBarButtonItem()
        editItem.rx.tap.withLatestFrom(rightItemState.asObservable())
        .map { $0.reversedValue }
        .bind(to: rightItemState)
        .disposed(by: bag)
        
        let items = Variable<[CollectionModel]>((1...10).map { CollectionModel.init(logo: UIImage.init(named: "Jietu20171220")!, title: "\($0)", id: $0)})
        dataSource.moveItem = { dataSource, sourceIndexPath, destinationIndexPath in
            var value = items.value
            let tmp = value.remove(at: sourceIndexPath.row)
            value.insert(tmp, at: destinationIndexPath.row)
            items.value = value
        }
        
        Observable.combineLatest(items.asObservable(), rightItemState.asObservable()) { (items, state) -> [CollectionModel] in
            switch state {
            case .editting:
                return items
            case .viewing:
                return items + [CollectionModel.init(logo: UIImage.init(named: "btn_add")!, title: "Add", id: 0)]
            }
        }
            .map { [SectionModel.init(model: "", items: $0)] }
        .bind(to: myCollectionView.rx.items(dataSource: dataSource))
        .disposed(by: bag)
    }
}
