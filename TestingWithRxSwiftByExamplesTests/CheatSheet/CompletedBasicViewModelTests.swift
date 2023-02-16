//
//  CompletedBasicViewModelTests.swift
//  TestingWithRxSwiftByExamplesTests
//
//  Created by Krystian Szutowicz on 16/02/2023.
//

import RxSwift
import RxTest
import XCTest
@testable import TestingWithRxSwiftByExamples

class CompletedBasicViewModelTests: XCTestCase {
    private let disposeBag = DisposeBag()
    var sut: BasicViewModel!
    var delegate: SomeDelegateMock!
    var service: SomeServiceMock!
    var scheduler: TestScheduler!
    
    override func setUp() {
        delegate = .init()
        service = .init()
        scheduler = .init(initialClock: 0, resolution: 1)
        sut = .init(service: service, delegate: delegate)
    }
    
    func test_callsDelegateOnInput() {
        sut.input.onNext(.callDelegate)
        
        XCTAssertTrue(delegate.invokedSomeMethod)
    }
    
    func test_produceBasicOutput_expectations() {
        let expectation = expectation(description: #function)
        sut.output
            .subscribe(onNext: {
                XCTAssertEqual($0, .init(title: "title"))
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        sut.input.onNext(.produceBasicOutput)
        
        waitForExpectations(timeout: 5)
    }
    
    func test_produceBasicOutput_observer() {
        let observer = scheduler.createObserver(BasicViewModel.Output.self)
        sut.output.bind(to: observer).disposed(by: disposeBag)
        
        sut.input.onNext(.produceBasicOutput)
        
        XCTAssertEqual(observer.events, [.next(0, .init(title: "title"))])
    }
    
    func test_produceErrorableOutput_elements() {
        service.stubbedGetDataResult = Observable.just(.init(id: 1, title: "title1"))
        let observer = scheduler.createObserver(BasicViewModel.Output.self)
        sut.output.bind(to: observer).disposed(by: disposeBag)
        
        sut.input.onNext(.produceErrorableOutput)
        
        XCTAssertEqual(observer.events, [.next(0, .init(title: "title1"))])
    }
    
    func test_produceErrorableOutput_errors() {
        let stubbedError = NSError(domain: "asd", code: 1)
        service.stubbedGetDataResult = Observable.error(stubbedError)
        let observer = scheduler.createObserver(BasicViewModel.Output.self)
        sut.output.bind(to: observer).disposed(by: disposeBag)
        
        sut.input.onNext(.produceErrorableOutput)
        
        XCTAssertEqual(observer.events, [.error(0, stubbedError)])
    }
}
