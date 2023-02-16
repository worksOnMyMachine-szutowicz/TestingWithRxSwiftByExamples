//
//  SomeDelegateMock.swift
//  TestingWithRxSwiftByExamplesTests
//
//  Created by Krystian Szutowicz on 16/02/2023.
//

@testable import TestingWithRxSwiftByExamples

class SomeDelegateMock: SomeDelegate {

    var invokedSomeMethod = false
    var invokedSomeMethodCount = 0

    func someMethod() {
        invokedSomeMethod = true
        invokedSomeMethodCount += 1
    }
}
