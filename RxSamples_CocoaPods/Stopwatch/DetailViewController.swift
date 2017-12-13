//
//  DetailViewController.swift
//  Stopwatch
//
//  Created by 左得胜 on 2017/12/7.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {

    // MARK: - Property
    /// 上个页面传入，本页的类型
    var type: StopwatchViewModelProtocol.Type = BasicViewModel.self
    /// 时间展示 label
    @IBOutlet weak var displayTimeLabel: UILabel!
    /// 重置 btn
    @IBOutlet weak var resetBtn: UIButton!
    /// 开始 btn
    @IBOutlet weak var startBtn: UIButton!
    /// 表格
    @IBOutlet weak var baseTableView: UITableView!
    
    private let bag = DisposeBag()
    
    private lazy var viewModel: StopwatchViewModelProtocol = self.type.init(input: (startAStopTrigger: self.startBtn.rx.tap.asObservable(), resetALapTrigger: self.resetBtn.rx.tap.asObservable()))
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Public Method
    
    // MARK: - Action
    

}

// MARK: - Private Method
private extension DetailViewController {
    private func setupUI() {
        
        viewModel.displayTime
        .bind(to: displayTimeLabel.rx.text)
        .disposed(by: bag)
        
        viewModel.resetALapStyle
        .bind(to: resetBtn.rx.style)
        .disposed(by: bag)
        
        viewModel.startAStopStyle
        .bind(to: startBtn.rx.style)
        .disposed(by: bag)
        
        viewModel.displayElements
            .bind(to: baseTableView.rx.items(cellIdentifier: "DetailTableViewCellID")) { [unowned self] (index, element, cell) in
                guard let label = cell.detailTextLabel else { return }
                
                // FIXME: - bag 怎么处理？
                element.displayTime.bind(to: label.rx.text).disposed(by: self.bag)
                if let textLabel = cell.textLabel {
                    element.title.bind(to: textLabel.rx.text).disposed(by: self.bag)
                }
                
                element.color.bind(to: label.rx.textColor).disposed(by: self.bag)
        }
        .disposed(by: bag)
        
    }
}
