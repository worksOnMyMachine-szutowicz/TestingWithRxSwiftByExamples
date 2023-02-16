//
//  AsyncViewModel.swift
//  TestingWithRxSwiftByExamples
//
//  Created by Krystian Szutowicz on 16/02/2023.
//

import RxSwift

extension AsyncViewModel {
    enum Input {
        case callDelegateOnMainThread
        case startTimer
        case switchToObservable
        case asyncTask
    }
    struct Output: Equatable {
        let title: String
        
        static func empty() -> Self {
            .init(title: "")
        }
    }
}

class AsyncViewModel {
    private let disposeBag = DisposeBag()
    private let service: SomeServiceProtocol
    private weak var delegate: SomeDelegate?
    private var scheduler: SchedulerType!
    
    let input = PublishSubject<Input>()
    let output = PublishSubject<Output>()
    
    init(service: SomeServiceProtocol, delegate: SomeDelegate?, scheduler: SchedulerType = MainScheduler.asyncInstance) {
        self.service = service
        self.delegate = delegate
        self.scheduler = scheduler
        
        setupBindings()
    }
    
    private func setupBindings() {
        
        // MARK: - Delegate call on main thread on input
        input
            .filter { $0 == .callDelegateOnMainThread }
            .observe(on: scheduler)
            .withUnretained(self)
            .subscribe(onNext: { vm, _ in
                vm.delegate?.someMethod()
            }).disposed(by: disposeBag)
        
        // MARK: - Timer
        let timer = Observable<Int>.interval(.seconds(1), scheduler: scheduler)
            .take(2)
        input
            .filter { $0 == .startTimer }
            .flatMap { _ in timer }
            .map { .init(title: "\($0)") }
            .bind(to: output)
            .disposed(by: disposeBag)
        
        // MARK: Switch to observable
        input
            .filter { $0 == .switchToObservable }
            .withUnretained(self)
            .flatMapLatest { vm, _ in
                vm.service.observableProperty
            }.map { .init(title: $0) }
            .bind(to: output)
            .disposed(by: disposeBag)
        
        // MARK: - Async task
        input
            .filter { $0 == .asyncTask }
            .flatMapLatest { _ in
                Observable.create { observer in
                    Task {
                        observer.onNext(Output(title: "title"))
                        observer.onCompleted()
                    }
                    return Disposables.create()
                }
            }.bind(to: output)
            .disposed(by: disposeBag)
    }
}
