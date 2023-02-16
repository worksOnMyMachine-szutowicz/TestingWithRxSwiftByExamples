//
//  SomeServiceMock.swift
//  TestingWithRxSwiftByExamplesTests
//
//  Created by Krystian Szutowicz on 16/02/2023.
//

import RxSwift
@testable import TestingWithRxSwiftByExamples

class SomeServiceMock: SomeServiceProtocol {

    var invokedObservablePropertyGetter = false
    var invokedObservablePropertyGetterCount = 0
    var stubbedObservableProperty: Observable<String>!

    var observableProperty: Observable<String> {
        invokedObservablePropertyGetter = true
        invokedObservablePropertyGetterCount += 1
        return stubbedObservableProperty
    }

    var invokedGetData = false
    var invokedGetDataCount = 0
    var stubbedGetDataResult: Observable<DataModel>!

    func getData() -> Observable<DataModel> {
        invokedGetData = true
        invokedGetDataCount += 1
        return stubbedGetDataResult
    }
}
