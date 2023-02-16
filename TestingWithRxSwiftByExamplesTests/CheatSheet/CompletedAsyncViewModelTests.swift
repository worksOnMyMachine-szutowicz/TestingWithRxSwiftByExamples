//
//  CompletedAsyncViewModelTests.swift
//  TestingWithRxSwiftByExamplesTests
//
//  Created by Krystian Szutowicz on 16/02/2023.
//

import RxSwift
import RxTest
import XCTest
@testable import TestingWithRxSwiftByExamples

class CompletedAsyncViewModelTests: XCTestCase {
    private let disposeBag = DisposeBag()
    var sut: AsyncViewModel!
    var delegate: SomeDelegateMock!
    var service: SomeServiceMock!
    var scheduler: TestScheduler!
    
    override func setUp() {
        delegate = .init()
        service = .init()
        scheduler = .init(initialClock: 0, resolution: 1)
        sut = .init(service: service, delegate: delegate, scheduler: scheduler)
    }
    
    func test_callDelegateOnMainThread() {
        sut.input.onNext(.callDelegateOnMainThread)
        
        scheduler.start()
        
        XCTAssertTrue(delegate.invokedSomeMethod)
    }
    
    func test_timer() {
        let observer = scheduler.createObserver(AsyncViewModel.Output.self)
        sut.output.bind(to: observer).disposed(by: disposeBag)
        
        sut.input.onNext(.startTimer)
        
        scheduler.start()
        
        XCTAssertEqual(observer.events, [.next(1, .init(title: "0")), .next(2, .init(title: "1"))])
    }
    
    func test_switchObservable() {
        service.stubbedObservableProperty = scheduler.createColdObservable([.next(0, "anything"), .next(1, "anything22")]).asObservable()
        let observer = scheduler.createObserver(AsyncViewModel.Output.self)
        sut.output.bind(to: observer).disposed(by: disposeBag)
        
        sut.input.onNext(.switchToObservable)
        
        scheduler.start()
        
        XCTAssertEqual(observer.events, [.next(0, .init(title: "anything")), .next(1, .init(title: "anything22"))])
    }
        
    func test_asyncTask() {
        let expectation = expectation(description: #function)
        
        sut.output
            .subscribe(onNext: {
                XCTAssertEqual($0, .init(title: "title"))
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        sut.input.onNext(.asyncTask)
        
        waitForExpectations(timeout: 5)
    }
}
