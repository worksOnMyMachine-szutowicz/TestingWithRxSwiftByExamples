//
//  SomeService.swift
//  TestingWithRxSwiftByExamples
//
//  Created by Krystian Szutowicz on 16/02/2023.
//

import RxSwift

protocol SomeServiceProtocol {
    var observableProperty: Observable<String> { get }
    func getData() -> Observable<DataModel>
}

struct DataModel {
    let id: Int
    let title: String
}

class SomeService: SomeServiceProtocol {
    let observableProperty: Observable<String> = .just("")
    
    func getData() -> Observable<DataModel> {
        .just(DataModel(id: 1, title: "title"))
    }
}
