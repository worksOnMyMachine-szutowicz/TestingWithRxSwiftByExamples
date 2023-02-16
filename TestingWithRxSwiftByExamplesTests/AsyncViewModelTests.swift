//
//  AsyncViewModelTests.swift
//  TestingWithRxSwiftByExamplesTests
//
//  Created by Krystian Szutowicz on 16/02/2023.
//

import RxSwift
import RxTest
import XCTest
@testable import TestingWithRxSwiftByExamples

class AsyncViewModelTests: XCTestCase {
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
        
    }
    
    func test_timer() {

    }
    
    func test_switchObservable() {

    }
        
    func test_asyncTask() {

    }
}
