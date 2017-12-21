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
    
    private let items = Variable<[CollectionModel]>((1...10).map { CollectionModel.init(logo: UIImage.init(named: "Jietu20171220")!, title: "\($0)", id: $0)})
    
//    private let dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<String, CollectionModel>>?
    
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
}

// MARK: - Private Method
private extension CollectionExapmleViewController {
    private func setupUI() {
        // navigationItem
        rightItemState.asObservable()
            .map { $0.barTitle }
        .bind(to: editItem.rx.title)
        .disposed(by: bag)
        
//        let editItem = UIBarButtonItem()
        editItem.rx.tap.withLatestFrom(rightItemState.asObservable())
        .map { $0.reversedValue }
            .share(replay: 1)
        .bind(to: rightItemState)
        .disposed(by: bag)
        
        // 数据源
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, CollectionModel>>(configureCell: { [unowned self] (dataSource, collectionView, indexPath, item) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCellID", for: indexPath) as! IconCollectionViewCell
            
            cell.iconImageView.image = item.logo
            cell.iconImageView.layer.cornerRadius = 8
            cell.iconImageView.layer.masksToBounds = true
            cell.titleLabel.text = item.title
            if item.id == 0 {
                cell.deleteBtn.isHidden = true
            } else {
                cell.deleteBtn.rx.tap
                    .subscribe(onNext: {
                        print(indexPath.row)
//                        print("*****\(item.id)*****\(item.title)")
                        
                    })
                    .disposed(by: cell.bag)
                
                self.rightItemState.asObservable()
                    .map { $0.isEditting }
                .bind(to: cell.rx.isEditting)
                .disposed(by: cell.bag)
            }
            
            return cell
        })
        
        dataSource.moveItem = { [unowned self] dataSource, sourceIndexPath, destinationIndexPath in
            var value = self.items.value
            let tmp = value.remove(at: sourceIndexPath.row)
            value.insert(tmp, at: destinationIndexPath.row)
            self.items.value = value
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
        
        // 长按手势
        let longPress = UILongPressGestureRecognizer()
        longPress.rx.event
            .subscribe(onNext: { [unowned self] (gesture) in
                switch gesture.state {
                case .began:
                    guard let selectedIndexPath = self.myCollectionView.indexPathForItem(at: gesture.location(in: self.myCollectionView)) else {
                        break
                    }
                    self.rightItemState.value = .editting
                    if #available(iOS 9.0, *) {
                        self.myCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
                    } else {
                        // Fallback on earlier versions
                        print("不支持 iOS9以下版本")
                    }

                case .changed:
                    if #available(iOS 9.0, *) {
                        self.myCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
                    } else {
                        // Fallback on earlier versions
                        print("不支持 iOS9以下版本")
                    }

                case .ended:
                    if #available(iOS 9.0, *) {
                        self.myCollectionView.endInteractiveMovement()
                    } else {
                        // Fallback on earlier versions
                        print("不支持 iOS9以下版本")
                    }

                case .cancelled, .failed, .possible:
                    if #available(iOS 9.0, *) {
                        self.myCollectionView.cancelInteractiveMovement()
                    } else {
                        // Fallback on earlier versions
                        print("不支持 iOS9以下版本")
                    }
                }
            })
        .disposed(by: bag)

        myCollectionView.addGestureRecognizer(longPress)

        myCollectionView.rx.modelSelected(CollectionModel.self)
            .subscribe(onNext: { (model) in
                if model.id == 0 {
                    let nextID = (self.items.value.max(by: { $0.id < $1.id })?.id ?? 0) + 1
                    self.items.value.append(CollectionModel.init(logo: UIImage.init(named: "Jietu20171220")!, title: String(nextID), id: nextID))

                    return
                }

                if self.rightItemState.value.isEditting { return }
                DSProgressHUD.showMessage(title: nil, message: model.title)

            })
        .disposed(by: bag)
        
    }
}
