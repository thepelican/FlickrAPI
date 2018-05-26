//
//  FlickrObject.swift
//  FlickrDeloitte
//
//  Created by Leonard Wu on 25/5/18.
//  Copyright © 2018 Marco Prayer. All rights reserved.
//

import Foundation

/*I decided to use a struct because most likely we wont need inheritance in here.. This could be easily changed with a class */

struct FlickrObject: Decodable {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var ispublic: Int
    var isfriend: Int
    var isfamily: Int
    
}

struct FlickrPhotos: Decodable {
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var total: String?
    var photo: [FlickrObject]?
}

struct FlickrContainer: Decodable {
    var photos: FlickrPhotos?
    var stat: String?
}
