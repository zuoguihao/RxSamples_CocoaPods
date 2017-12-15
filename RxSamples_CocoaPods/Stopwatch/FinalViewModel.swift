//
//  FinalViewModel.swift
//  Stopwatch
//
//  Created by 左得胜 on 2017/12/7.
//  Copyright © 2017年 左得胜. All rights reserved.
//

import Foundation
import RxSwift

struct FinalViewModel: StopwatchViewModelProtocol {
    
    // MARK: - Custom Property
    private enum Input {
        case start, stop, lap, reset
    }
    
    private enum State {
        case timing, stopped, reseted
    }
    
    private let bag = DisposeBag()
    
    private let automaton: Automaton<State, Input>
    
    // MARK: - LifeCycle
    var startAStopStyle: Observable<DSStyle.Button>
    
    var resetALapStyle: Observable<DSStyle.Button>
    
    var displayTime: Observable<String>
    
    var displayElements: Observable<[(title: Observable<String>, displayTime: Observable<String>, color: Observable<UIColor>)]>
    
    init(input: (startAStopTrigger: Observable<Void>, resetALapTrigger: Observable<Void>)) {
        let startTrigger = input.startAStopTrigger.share(replay: 1)
        let resetTrigger = input.resetALapTrigger.share(replay: 1)
        
        let mappings: [Automaton<State, Input>.EffectMapping] = [
            .start | [.reseted, .stopped].contains => .timing  | .empty(),
            .stop  | .timing                       => .stopped | .empty(),
            .reset | .stopped                      => .reseted | .empty(),
        ]
        
        let (inputSignal, inputObserver) = Observable<Input>.pipe()
        
        automaton = Automaton(state: State.reseted, input: inputSignal, mapping: reduce(mappings), strategy: .latest)
        
        Observable.from([
            startTrigger
            .withLatestFrom(automaton.state.asObservable())
                .map({ (state) -> Input in
                    switch state {
                    case .reseted, .stopped:
                        return Input.start
                    case .timing:
                        return Input.stop
                    }
                }),
            resetTrigger
            .withLatestFrom(automaton.state.asObservable())
                .flatMap({ (state) -> Observable<Input> in
                    switch state {
                    case .reseted, .timing:
                        return Observable.empty()
                    case .stopped:
                        return Observable.just(Input.reset)
                    }
                })
            ])
        .merge()
        .subscribe(onNext: inputObserver.onNext)
        .disposed(by: bag)
        
        let state = automaton.state.asObservable().share(replay: 1)
        
        resetALapStyle = state
            .map({ (state) in
                switch state {
                case .reseted:
                    return DSStyle.Button(title: "Lap", titleColor: UIColor.white, isEnabled: false, backgroundImage: #imageLiteral(resourceName: "gray"))
                case .stopped:
                    return DSStyle.Button(title: "Reset", titleColor: UIColor.white, isEnabled: true, backgroundImage: #imageLiteral(resourceName: "gray"))
                case .timing:
                    return DSStyle.Button(title: "Lap", titleColor: UIColor.white, isEnabled: true, backgroundImage: #imageLiteral(resourceName: "gray"))
                }
            })
        
        startAStopStyle = state
            .map({ (state) in
                switch state {
                case .reseted:
                    return DSStyle.Button(title: "Start", titleColor: UIColor.green, isEnabled: true, backgroundImage: #imageLiteral(resourceName: "green"))
                case .stopped:
                    return DSStyle.Button(title: "Start", titleColor: UIColor.green, isEnabled: true, backgroundImage: #imageLiteral(resourceName: "green"))
                case .timing:
                    return DSStyle.Button(title: "Stop", titleColor: UIColor.red, isEnabled: true, backgroundImage: #imageLiteral(resourceName: "red"))
                }
            })
        
        let timeInfo = automaton.state.asObservable()
            .flatMapLatest { (state) -> Observable<State> in
                switch state {
                case .reseted, .stopped:
                    return Observable.just(state)
                case .timing:
                    return Observable<Int>.interval(0.01, scheduler: MainScheduler.instance).map({ (_) in
                        State.timing
                    })
                }
        }
            .scan((time: 0, state: State.reseted)) { (acc, x) -> (time: TimeInterval, state: State) in
                switch x {
                case .reseted:
                    return (time: 0, state: x)
                case .stopped:
                    return (time: acc.time, state: x)
                case .timing:
                    return (time: acc.time + 0.01, state: x)
                }
        }
        .share(replay: 1)
        
        displayTime = timeInfo
            .map { $0.time }
        .map(DSTool.convertToTimeInfo)
        
        let lap = Observable.from([
            resetTrigger,
            automaton.state.asObservable()
                .scan((pre: State.reseted, current: State.reseted), accumulator: { (acc, x) in
                    (pre: acc.current, current: x)
                })
                .flatMap({ (state) -> Observable<Void> in
                    if state.pre == State.reseted && state.current == State.timing {
                        return Observable.just(())
                    } else {
                        return Observable.empty()
                    }
                })
            .delay(0.01, scheduler: MainScheduler.instance)
            ])
        .merge()
        
        displayElements = timeInfo
        .sample(lap)
            .scan((preTime: 0, max: 0, min: 0, info: [(lap: String, time: Observable<TimeInterval>)]()), accumulator: { (acc, x) -> (preTime: TimeInterval, max: TimeInterval, min: TimeInterval, info: [(lap: String, time: Observable<TimeInterval>)]) in
                switch x.state {
                case State.reseted:
                    return (preTime: 0, max: 0, min: 0, info: [])
                case State.timing, State.stopped:
                    let offset = x.time - acc.preTime
                    
                    if let _ = acc.info.first {
                        let info = [(lap: "Lap \(acc.info.count + 1)", time: timeInfo.map { $0.time - x.time }), (lap: "Lap \(acc.info.count)", time: Observable<TimeInterval>.just(offset))] + acc.info.dropFirst()
                        
                        return (preTime: x.time, max: offset >= acc.max ? offset : acc.max, min: offset <= acc.min ?offset : acc.min, info: info)
                    } else {
                        return (preTime: 0, max: 0, min: Double.infinity, info: [(lap: "Lap 1", time: timeInfo.map { $0.time })])
                    }
                }
            })
            .map({ (element) in
                element.info.map({ (e) in
                    return (
                    title: Observable.just(e.lap),
                    displayTime: e.time.map(DSTool.convertToTimeInfo),
                    color: e.time.take(1)
                        .map({ (time) -> UIColor in
                            guard element.max != element.min && time != 0 else {
                                return UIColor.white
                            }
                            if time == element.max {
                                return UIColor.red
                            } else if time == element.min {
                                return UIColor.green
                            } else {
                                return UIColor.white
                            }
                        })
                    )
                })
            })
        
        
    }
    
}
