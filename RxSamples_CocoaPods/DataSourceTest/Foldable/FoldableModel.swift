//
//  FoldableModel.swift
//  DataSourceTest
//
//  Created by 左得胜 on 2017/12/26.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

private let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = DateFormatter.Style.long
    formatter.locale = Locale(identifier: "zh-CN")
    
    return formatter
}()

struct FoldableModel: Equatable, IdentifiableType {
    static func ==(lhs: FoldableModel, rhs: FoldableModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    var identity: String {
        return id
    }
    
    let type: Type
    let id: String
    var subItems: Observable<[FoldableModel]>
    
    var allItems: Observable<[FoldableModel]> {
        return Observable.combineLatest(Observable.just([self]), self.subItems, resultSelector: +)
    }
    
    private let bag = DisposeBag()
    
    
    enum `Type` {
        case display(title: Variable<String>, type: Display, isFolded: Variable<Bool>)
        case input(Input)
    }
    
    enum Display {
        case fullName
        case dateOfBirth
        case maritalStatus
        case favoriteSport
        case favoriteColor
        case level
        
        var subTitle: String {
            switch self {
            case .fullName: return "FullName"
            case .dateOfBirth: return "Date Of Birth"
            case .maritalStatus: return "Marital Status"
            case .favoriteSport: return "Favorite Sport"
            case .favoriteColor: return "Favorite Color"
            case .level: return "Level"
            }
        }
    }
    
    enum Input {
        case textField(text: Variable<String>, placeHolder: String)
        case datePick(Variable<Date>)
        case status(title: String, inOn: Variable<Bool>)
        case title(title: String, favorite: Variable<String>)
        case level(Variable<Float>)
    }
    
    init(defaultTitle: String, displayType: Display) {
        self.init(type: Type.display(title: Variable(defaultTitle), type: displayType, isFolded: Variable(false)))
    }
    
    private init(type: Type) {
        self.type = type
        
        switch type {
        case let .display(title, type, isExpanded):
            var tmpSubItems: [FoldableModel] = []
            
            switch type {
            case .fullName:
                let fullName = title.value.components(separatedBy: " ")
                let firstName = Variable(fullName[0] )
                let lastName = Variable(fullName[1] )
                
                let firstSubItem = FoldableModel(type: .input(.textField(text: firstName, placeHolder: "First Name")))
                let lastSubItem = FoldableModel(type: .input(.textField(text: lastName, placeHolder: "Last Name")))
                
                tmpSubItems = [firstSubItem, lastSubItem]
                
                Observable.combineLatest(firstName.asObservable(), lastName.asObservable(), resultSelector: { $0 + " " + $1 })
                    .bind(to: title)
                .disposed(by: bag)
                id = "fullName"
                
            case .dateOfBirth:
                let date = Variable(Date())
                let subItem = FoldableModel(type: .input(.datePick(date)))
                
                tmpSubItems = [subItem]
                
                date.asObservable()
                    .map({ (date) in
                        return formatter.string(from: date)
                    })
                .bind(to: title)
                .disposed(by: bag)
                
                id = "dateOfBirth"
                
            case .maritalStatus:
                id = "maritalStatus"
                let isMarried = Variable(false)
                let subItem = FoldableModel(type: .input(.status(title: "关：单身，开：已婚", inOn:  isMarried)))
                tmpSubItems = [subItem]
                isMarried.asObservable().skip(1)
                    .map { $0 ? "已婚" : "单身" }
                .bind(to: title)
                .disposed(by: bag)
                
            case .favoriteSport:
                id = "favoriteSport"
                let football = FoldableModel(type: .input(.title(title: "Football", favorite: title)))
                let basketball = FoldableModel(type: .input(.title(title: "Baskerball", favorite: title)))
                let baseball = FoldableModel(type: .input(.title(title: "Baseball", favorite: title)))
                let volleyball = FoldableModel(type: .input(.title(title: "Volleyball", favorite: title)))
                tmpSubItems = [football, basketball, baseball, volleyball]
                
            case .favoriteColor:
                id = "favoriteColor"
                let red = FoldableModel(type: .input(.title(title: "Red", favorite: title)))
                let green = FoldableModel(type: .input(.title(title: "Green", favorite: title)))
                let blue = FoldableModel(type: .input(.title(title: "Blue", favorite: title)))
                tmpSubItems = [red, green, blue]
                
            case .level:
                id = "level"
                let level = Variable(Float(0))
                let subItem = FoldableModel(type: .input(.level(level)))
                tmpSubItems = [subItem]
                level.asObservable()
                .map(String.init)
                .bind(to: title)
                .disposed(by: bag)
                
            }
            
            switch type {
            case .favoriteColor, .favoriteSport:
                title.asObservable().skip(1)
                    .subscribe(onNext: { (_) in
                        isExpanded.value = !isExpanded.value
                    })
                .disposed(by: bag)
                
            default:
                break
            }
            
            self.subItems = isExpanded.asObservable()
//                .map { $0 ? subItems : [] }
                .map({ (isTrue) in
                    isTrue ? tmpSubItems : []
                })
            .share(replay: 1)
          
        case let .input(input):
            switch input {
            case .textField(_, let placeHolder):
                id = "textField\(placeHolder)"
            case let .datePick(date):
                id = "dataPick\(date.value)"
            case let .status(title, _):
                id = "status\(title)"
            case let .title(title, _):
                id = "title\(title)"
            case let .level(level):
                id = "level\(level)"
            }
            
            self.subItems = Observable.just([]).share(replay: 1)
        }
        
    }
    
}

enum FoldableEnum: String, IdentifiableType {
    var identity: String {
        return rawValue
    }
    
    case personal = "Personal"
    case preferences = "Preferences"
    case workExperience = "Work Experience"
}
