//
//  ViewModel.swift
//  FlickrDeloitte
//
//  Created by Leonard Wu on 25/5/18.
//  Copyright © 2018 Marco Prayer. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {
    
    private let apiManager: APIManager?
    let page = Variable<Int>.init(1)
    let flickerObjectList: Driver<[FlickrObject]>!
    let 
    init(APIManager: APIManager = APIManager()) {
        self.apiManager = APIManager
        
        setupAPI()
    }

    func setupAPI() {
        page.asObservable().subscribe(onNext: { (page) in
            self.apiManager?.getFlickrPhotosContainer(query: <#T##String#>, page: <#T##Int#>)
        }, onError: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>, onCompleted: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onDisposed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
    }
}
