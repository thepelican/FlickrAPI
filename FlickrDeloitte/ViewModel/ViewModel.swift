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
    var flickerObjectList = Variable<[FlickrObject]>.init([])
    var page = Variable<Int>.init(0)
    let disposeBag = DisposeBag()
    let query = Variable<String>.init("test")

    init(APIManager: APIManager = APIManager()) {
        self.apiManager = APIManager
        
        query.asObservable().filter{ $0 != "" }
            .debug()
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe({(query) in
                self.refreshResults(query: query.element!)
        }).disposed(by: disposeBag)
        
        page.asObservable()
            .filter{ $0 != 1 || $0 != 0 }
            .subscribe({(page) in
            self.refreshResults(query: self.query.value, page: page.element!)
            }
        ).disposed(by: disposeBag)

    }
    
    func refreshResults(query: String, page: Int = 1) {
        self.apiManager?.getFlickrPhotosContainer(query: query, page: page).subscribe(onNext: { (apiResult) in
                switch apiResult {
                case .Success(let container):
                    if let photos = container.photos?.photo {
                        if page != 1 {
                            for single in photos {
                                self.flickerObjectList.value.append(single)
                            }
                        } else {
                            self.flickerObjectList.value = photos
                        }
                    } else {
                        self.flickerObjectList.value = []
                    }
                case .Error:
                    self.flickerObjectList.value = []
                }
            }).disposed(by: disposeBag)
    }
    

    func getImageURL(_ model: FlickrObject) -> URL {
        let urlString = "http://farm\(model.farm).static.flickr.com/\(model.server)/\(model.id)_\(model.secret).jpg"
        
        if let url = URL(string: urlString) {
            return url
        } else {
            return URL(string: "http://via.placeholder.com/350x150")!
        }
    }
    
}
