//
//  ViewModel.swift
//  RxSwiftMVVM
//
//  Created by Dalton Claybrook on 10/6/17.
//  Copyright © 2017 Dalton Claybrook. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

class ViewModel {
    
    // MARK: Public Properties
    
    var emailStringObservable: Observable<String> {
        return emails
            .asObservable()
            .map { emails -> String in
                return emails.joined(separator: "\n")
        }
    }
    var isLoadingObservable: Observable<Bool> {
        return isLoading.asObservable()
    }
    var tapObserver: AnyObserver<Void> {
        return tapSubject.asObserver()
    }
    
    // MARK: Private Properties
    
    private let emails = Variable([String]())
    private let isLoading = Variable(false)
    private let tapSubject = PublishSubject<Void>()
    private let apiProvider = MoyaProvider<API>()
    private let disposeBag = DisposeBag()
    
    init() {
        self.observeTap()
    }
    
    // MARK: Private
    
    private func observeTap() {
        let apiProvider = self.apiProvider
        let isLoading = self.isLoading
        let emails = self.emails
        
        tapSubject
            .asObservable()
            .do(onNext: { _ in isLoading.value = true })
            .do(onNext: { _ in emails.value = [] })
            .flatMap { _ in
                return apiProvider.rx.request(.posts)
            }
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .flatMap { object -> Observable<Response> in
                let json = JSON(object)
                let postId = json[0]["id"].int ?? 1
                return apiProvider.rx.request(.comments(postId: postId)).asObservable()
            }
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .map { object -> [String] in
                let json = JSON(object)
                return json.array?.flatMap { $0["email"].string } ?? []
            }
            .catchErrorJustReturn([])
            .do(onNext: { _ in isLoading.value = false })
            .bind(to: self.emails)
            .disposed(by: self.disposeBag)
    }
}
