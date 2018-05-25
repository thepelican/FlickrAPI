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
    var id: Int?
    var owner: String?
    var secret: String?
    var server: Int?
    var farm: Int
    var title: String?
    var ispublic: Bool?
    var isfriend: Bool?
    var isfamily: Bool?
}
