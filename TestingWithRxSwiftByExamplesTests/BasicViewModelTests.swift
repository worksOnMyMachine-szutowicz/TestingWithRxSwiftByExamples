//
//  BasicViewModelTests.swift
//  TestingWithRxSwiftByExamplesTests
//
//  Created by Krystian Szutowicz on 16/02/2023.
//

import RxSwift
import RxTest
import XCTest
@testable import TestingWithRxSwiftByExamples

class BasicViewModelTests: XCTestCase {
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

    }
    
    func test_produceBasicOutput_expectations() {

    }
    
    func test_produceBasicOutput_observer() {

    }
    
    func test_produceErrorableOutput_elements() {

    }
    
    func test_produceErrorableOutput_errors() {

    }
}
