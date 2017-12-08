//
//  BasicViewModel.swift
//  Stopwatch
//
//  Created by 左得胜 on 2017/12/7.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import Foundation
import RxSwift

struct BasicViewModel: StopwatchViewModelProtocol {
    
    var startAStopStyle: Observable<DSStyle.Button>
    
    var resetALapStyle: Observable<DSStyle.Button>
    
    var displayTime: Observable<String>
    
    var displayElements: Observable<[(title: Observable<String>, displayTime: Observable<String>, color: Observable<UIColor>)]>
    
    // MARK: - CuctomProperty
    private enum State {
        case timing, stopped
    }
    
    init(input: (startAStopTrigger: Observable<Void>, resetALapTrigger: Observable<Void>)) {
        let state = input.startAStopTrigger
            .scan(State.stopped) { (s, _) in
                switch s {
                case .stopped:
                    return State.timing
                case .timing:
                    return State.stopped
                }
        }
        .share(replay: 1)
        
        displayTime = state
            .flatMapLatest { state -> Observable<TimeInterval> in
                switch state {
                case .stopped:
                    return Observable.empty()
                case .timing:
                    return Observable<Int>.interval(0.01, scheduler: MainScheduler.instance).map { _ in 0.01 }
                }
            }
        .scan(0, accumulator: +)
        .startWith(0)
        .map(DSTool.convertToTimeInfo)
        
        startAStopStyle = state
            .map({ (state) in
                switch state {
                case .stopped:
                    return DSStyle.Button(title: "Start", titleColor: UIColor.green, isEnabled: true, backgroundImage: #imageLiteral(resourceName: "green"))
                case .timing:
                    return DSStyle.Button(title: "Stop", titleColor: UIColor.red, isEnabled: true, backgroundImage: #imageLiteral(resourceName: "red"))
                }
            })
        
        resetALapStyle = Observable.just(DSStyle.Button(title: "", titleColor: UIColor.white, isEnabled: false, backgroundImage: #imageLiteral(resourceName: "gray")))
        displayElements = Observable.empty()
    }
    
    
}
