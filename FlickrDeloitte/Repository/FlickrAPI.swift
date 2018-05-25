//
//  FlickrAPI.swift
//  FlickrDeloitte
//
//  Created by Leonard Wu on 25/5/18.
//  Copyright © 2018 Marco Prayer. All rights reserved.
//

import Foundation
import RxSwift

//classic protocol mocking

enum APICall {
    case Photo(userQuery: String)
}

protocol FlickrAPI {
    func getObjects(apiCall: APICall) -> Observable<String>
}

extension URLSession: FlickrAPI {
    func getObjects(apiCall: APICall) -> Observable<String> {
        return Observable.just("test")
    }
}

class APIManager {
    private let session: FlickrAPI
    
    init(session: FlickrAPI) {
        self.session = session
    }
    
    func getFlickrObjects() -> Observable<[FlickrObject]> {
        return session.getObjects(apiCall: .Photo(userQuery: "text")).map({ (json) -> [FlickrObject] in
            return [FlickrObject()]
        })
    }
}



class MockURLSession: FlickrAPI {
    func getObjects(apiCall: APICall) -> Observable<String> {
        return Observable.just("test")
    }
    
}
