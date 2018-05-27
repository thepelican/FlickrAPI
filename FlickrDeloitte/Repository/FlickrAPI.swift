//
//  FlickrAPI.swift
//  FlickrDeloitte
//
//  Created by Marco Prayer on 25/5/18.
//  Copyright © 2018 Marco Prayer. All rights reserved.
//

import Foundation
import RxSwift

//classic protocol mocking

enum APICall {
    case Photo(userQuery: String, page: Int)
}

enum APIResult<T> {
    case Success(T)
    case Error(ErrorType)
}

enum ErrorType {
    case genericError
}

protocol FlickrAPI {
    func GET(apiCall: APICall) -> Observable<Data>
}

extension URLSession: FlickrAPI {    
    func GET(apiCall: APICall) -> Observable<Data> {
        
        switch apiCall {
            
        case .Photo(let userQuery, let page):
            return Observable<Data>.create { observer in
                let endpoint = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=96358825614a5d3b1a1c3fd87fca2b47&text=\(userQuery)&format=json&nojsoncallback=1&page=\(page)"
                
                print(endpoint)
                let endpointUrl = URL(string: endpoint)
                
                var request = URLRequest(url: endpointUrl!)
                request.httpMethod = "GET"
                request.addValue("application/json", forHTTPHeaderField: "Accept")

                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let _ = data {
                        observer.onNext(data!)
                    } else {
                        observer.onError(error!)
                    }
                    observer.onCompleted()
                }
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }
        }
    }
}

class APIManager {
    private let session: FlickrAPI
    
    init(session: FlickrAPI = URLSession.shared) {
        self.session = session
    }
    
    func getFlickrPhotosContainer(query: String, page: Int) -> Observable<APIResult<FlickrContainer>> {
        return session.GET(apiCall: .Photo(userQuery: query, page: page)).map({ (json) -> APIResult<FlickrContainer> in
            let jsonDecoder = JSONDecoder()
            
            do {
                let flickr:FlickrContainer = try jsonDecoder.decode(FlickrContainer.self, from: json)
                if flickr.stat != nil && flickr.stat == "fail" { return .Error(.genericError) }
                return .Success(flickr)
            } catch {
                return .Error(.genericError)
            }
        })
    }
}



class MockURLSession: FlickrAPI {
    func GET(apiCall: APICall) -> Observable<Data> {
        let bundle = Bundle.main
        let path = bundle.path(forResource: "jsonData", ofType: "json")
        
        let data: NSData? = NSData(contentsOfFile: path!)

        return Observable.just(data! as Data)
    }
    
}
