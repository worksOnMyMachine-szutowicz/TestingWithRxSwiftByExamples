//
//  BasicViewModel.swift
//  TestingWithRxSwiftByExamples
//
//  Created by Krystian Szutowicz on 16/02/2023.
//

import RxSwift
import RxCocoa

extension BasicViewModel {
    enum Input {
        case callDelegate
        case produceBasicOutput
        case produceErrorableOutput
    }
    struct Output: Equatable {
        let title: String
        
        static func empty() -> Self {
            .init(title: "")
        }
    }
}

class BasicViewModel {
    private let disposeBag = DisposeBag()
    private let service: SomeServiceProtocol
    private weak var delegate: SomeDelegate?
    
    let input = PublishSubject<Input>()
    let output = PublishSubject<Output>()
    
    init(service: SomeServiceProtocol, delegate: SomeDelegate?) {
        self.service = service
        self.delegate = delegate
        
        setupBindings()
    }
    
    private func setupBindings() {
        
        // MARK: - Delegate call on input
        input
            .filter { $0 == .callDelegate }
            .withUnretained(self)
            .subscribe(onNext: { vm, _ in
                vm.delegate?.someMethod()
            }).disposed(by: disposeBag)
        
        // MARK: - Output on input
        input
            .filter { $0 == .produceBasicOutput }
            .map { _ in .init(title: "title") }
            .bind(to: output)
            .disposed(by: disposeBag)
        
        // MARK: - Errorable output on input
        input
            .filter { $0 == .produceErrorableOutput }
            .withUnretained(self)
            .flatMap { vm, _ in
                vm.service.getData()
            }.map { .init(title: $0.title) }
            .bind(to: output)
            .disposed(by: disposeBag)
    }
}
