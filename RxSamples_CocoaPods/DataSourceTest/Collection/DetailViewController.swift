//
//  DetailViewController.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/22.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class DetailViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myEditItem: UIBarButtonItem!
    

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
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
}

// MARK: - Private Method
private extension DetailViewController {
    private func setupUI() {
        rightItemState.asObservable()
            .map { $0.barTitle }
            .bind(to: myEditItem.rx.title)
            .disposed(by: bag)
        
        myEditItem.rx.tap.withLatestFrom(rightItemState.asObservable())
            .map { $0.reversedValue }
            .bind(to: rightItemState)
            .disposed(by: bag)
        
        // 数据源
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<AnimatableSectionModel<String, CollectionModel>>.init(configureCell: { [unowned self] (dataSource, collectionView, indexPath, item) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCollectionViewCellID", for: indexPath) as! IconCollectionViewCell
            
            cell.iconIV.image = item.logo
            cell.titleLabel.text = item.title
            
            if item.id == 0 {
                cell.deleteBtn.isHidden = true
            } else {
                cell.deleteBtn.rx.tap
                    .subscribe(onNext: {
//                        print("self.items: \(self.items.value)*****indexPath.item: \(indexPath.item), id: \(item.id)")
                        guard let index = self.items.value.index(of: item) else {
                            return
                        }
                        self.items.value.remove(at: index.hashValue)
                        
                    })
                    .disposed(by: cell.bag)
                
                self.rightItemState.asObservable()
                    .map { $0.isEditting }
                    .bind(to: cell.rx.isEditting)
                    .disposed(by: cell.bag)
            }
            
            return cell
            }, configureSupplementaryView: { (source, collectionView, str, indexPath) -> UICollectionReusableView in
                return collectionView.dequeueReusableCell(withReuseIdentifier: "IconCollectionViewCellID", for: indexPath) as! IconCollectionViewCell
        })
        
        dataSource.moveItem = { [unowned self] (dataSource, sourceIndexPath, destinationIndexPath) in
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
            .map { [AnimatableSectionModel.init(model: "", items: $0)] }
            .bind(to: myCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        myCollectionView.rx.modelSelected(CollectionModel.self)
            .subscribe(onNext: { (model) in
                if model.id == 0 {
                    let nextID = (self.items.value.max(by: { $0.id < $1.id })?.id ?? 0) + 1
                    self.items.value.append(CollectionModel(logo: UIImage(named: "Jietu20171220")!, title: "\(nextID)", id: nextID))
                    return
                }
                
                if self.rightItemState.value.isEditting { return }
                DSProgressHUD.showMessage(title: nil, message: model.title)
            })
        .disposed(by: bag)
        
        // 长按功能
        let longPress = UILongPressGestureRecognizer()
        longPress.rx.event
            .subscribe(onNext: { [unowned self] (gesture) in
                switch gesture.state {
                case .began:
                    guard let selectedIndexPath = self.myCollectionView.indexPathForItem(at: gesture.location(in: self.myCollectionView)) else {
                        return
                    }
                    self.rightItemState.value = .editting
                    self.myCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
                    
                case .changed:
                    self.myCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: self.myCollectionView))
                    
                case .ended:
                    self.myCollectionView.endInteractiveMovement()
                    
                case .cancelled, .failed, .possible:
                    self.myCollectionView.cancelInteractiveMovement()
                    
                }
            })
        .disposed(by: bag)
        myCollectionView.addGestureRecognizer(longPress)
    }
}


