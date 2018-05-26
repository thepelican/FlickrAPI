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
    let page = BehaviorRelay<Int>.init(value: 1)
    var flickerObjectList: Driver<[FlickrObject]>!
    let query: Observable<String>
    let disposeBag = DisposeBag()

    init(APIManager: APIManager = APIManager(), query: Observable<String> ) {
        self.apiManager = APIManager
        self.query = query
        
//        self.query
//        .filter{ $0 != "" }
//        .debug()
//        .throttle(0.5, scheduler: MainScheduler.instance)
//        .distinctUntilChanged()
//        .flatMap({ (query) in
//            APIManager.getFlickrPhotosContainer(query: query, page: 1)
//        }).map({ (apiResult) -> [FlickrObject] in
//            switch apiResult {
//            case .Success(let container):
//                return (container.photos?.photo!)!
//            case .Error:
//                return []
//            }
//        }).subscribe(onNext: { photo in
//            self.flickerObjectList.onNext(photo)
//        })
//
        
        
 
        self.flickerObjectList = Observable.combineLatest(query, page.asObservable()) { ($0, $1) }
            .debug()
            .flatMap({ (values) in
                APIManager.getFlickrPhotosContainer(query: values.0, page: values.1)
            }).map({ (apiResult) -> [FlickrObject] in
                switch apiResult {
                    case .Success(let container):
                        return (container.photos?.photo!)!
                    case .Error:
                        return []
                }
            })
            .asDriver(onErrorJustReturn: [])
        

    }


    func getImageURL(_ model: FlickrObject) -> URL {
//        http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg
        let urlString = "http://farm\(model.farm).static.flickr.com/\(model.server)/\(model.id)_\(model.secret).jpg"
        
        if let url = URL(string: urlString) {
            print(urlString)
            return url
        } else {
            return URL(string: "http://via.placeholder.com/350x150")!
        }
    }
    
}
