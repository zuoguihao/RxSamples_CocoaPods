//
//  RefreshViewController.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/26.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Alamofire
import SwiftyJSON
import MBProgressHUD
import SafariServices

class RefreshViewController: UIViewController {
    
    // MARK: - Property
    /// 表格
    @IBOutlet weak var myTableView: UITableView!
    /// 切换控制
    @IBOutlet weak var typeSegmentControl: UISegmentedControl!
    
    private let bag = DisposeBag()
    
    
    // MARK: - View LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
}

// MARK: - Private Method
private extension RefreshViewController {
    private func setupUI() {
        myTableView.rowHeight = UITableViewAutomaticDimension
        myTableView.estimatedRowHeight = 60
        myTableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        
        let footerView = UIView()
        footerView.backgroundColor = myTableView.backgroundColor
        footerView.frame.size.height = 8
        myTableView.tableFooterView = footerView
        
        myTableView.rx.enableAutoDeselect().disposed(by: bag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, RefreshModel>>(configureCell: { (_, tableView, indexPath, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: RefreshTableViewCell.reuseID, for: indexPath) as! RefreshTableViewCell
            cell.messageLabel.text = element.message
            cell.authorLabel.text = element.author
            
            return cell
        })
        
        let refreshControl = UIRefreshControl()
        if #available(iOS 10.0, *) {
            myTableView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
        let refresh = refreshControl.rx.controlEvent(.valueChanged)
        .startWith(())
        .share(replay: 1)
        
        
        let response = refresh
            .flatMap { self.ds_request(url: "https://api.github.com/repos/ReactiveX/RxSwift/commits", parameters: ["per_page": 10]) }
            .map { (json) -> [RefreshModel] in
                json.arrayValue.map { (json) in
                    let message = json["commit"]["message"].stringValue
                    let author = json["commit"]["author"]["name"].stringValue
                    let url = URL(string: json["html_url"].stringValue)!
                    
                    return RefreshModel(author: author, message: message, url: url)
                }
                
            }
            .map { [SectionModel.init(model: "", items: $0)] }
        .share(replay: 1)
        
        response.bind(to: myTableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        Observable.from([refresh.skip(1).map { true }, response.skip(1).map { _ in false }])
        .merge()
        .bind(to: refreshControl.rx.isRefreshing)
        .disposed(by: bag)
        
        Observable.from([refresh.take(1).map { true }, response.take(1).map { _ in false }])
        .merge()
        .bind(to: isLoading(view: myTableView))
        .disposed(by: bag)
        
        myTableView.rx.modelSelected(RefreshModel.self)
            .map { $0.url }
            .subscribe(onNext: { [unowned self] (url) in
                let safari = SFSafariViewController(url: url)
                self.showDetailViewController(safari, sender: nil)
            })
        .disposed(by: bag)
        
    }
    
    private func isLoading(view: UIView) -> AnyObserver<Bool> {
        return Binder.init(view, binding: { (hud, isLoading) in
            switch isLoading {
            case true:
                MBProgressHUD.showAdded(to: view, animated: true)
            case false:
                MBProgressHUD.hide(for: view, animated: true)
                break
            }
        }).asObserver()
    }
    
    /// 加载数据
    private func ds_request(url: URLConvertible, method: Alamofire.HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) -> Observable<JSON> {
        return Observable<JSON>.create({ (observer) in
            let task = request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .responseData(completionHandler: { (response) in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    switch response.result {
                    case let .success(data):
                        do {
                            let json = try JSON.init(data: data)
                            
                            observer.on(.next(json))
                            observer.on(.completed)
                        } catch {
                            observer.on(.error(error))
                        }
                        
                    case let .failure(error):
                        observer.on(.error(error))
                    }
                })
            return Disposables.create(with: task.cancel)
        })
    }
}

