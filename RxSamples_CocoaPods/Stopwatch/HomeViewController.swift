//
//  HomeViewController.swift
//  Stopwatch
//
//  Created by 左得胜 on 2017/12/6.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
//import RxDataSources

class HomeViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var baseTableView: UITableView! {
        didSet {
            baseTableView.rx.enableAutoDeselect().disposed(by: bag)
        }
    }
    let bag = DisposeBag()
    
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Public Method
    
    // MARK: - Action
    

}

// MARK: - Private Method
private extension HomeViewController {
    private func setupUI() {
        let items = Observable.just([
            HomeItemModel(title: "Basic", type: BasicViewModel.self)
            ])
        
        let baseTableView = UITableView()
        
        items
            .bind(to: baseTableView.rx.items(cellIdentifier: "HomeTableViewCellID")) { (index, element, cell) in
                cell.textLabel?.text = element.title
        }
        .disposed(by: bag)
        
        baseTableView.rx.modelSelected(HomeItemModel.self)
            .subscribe(onNext: { [weak self] (model) in
                let detailVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewControllerID") as! DetailViewController
//                detailVC
                self?.show(detailVC, sender: nil)
                
            })
        .disposed(by: bag)
    }
}
