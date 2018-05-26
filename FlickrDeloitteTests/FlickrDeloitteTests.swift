//
//  FlickrDeloitteTests.swift
//  FlickrDeloitteTests
//
//  Created by Leonard Wu on 25/5/18.
//  Copyright © 2018 Marco Prayer. All rights reserved.
//

import XCTest
import RxSwift

@testable import FlickrDeloitte

class FlickrDeloitteTests: XCTestCase {
    
    var viewModel: ViewModel?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.viewModel = ViewModel(APIManager: APIManager.init(session: MockURLSession()))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetImageUrl() {
        let FlikerTestObj = FlickrObject.init(id: "39593986652", owner: "36739135@N04", secret: "0ec416669f", server: "4740", farm: 5, title: "IMG_5508", ispublic: 1, isfriend: 0, isfamily: 0)
        
        let testableUrl = self.viewModel?.getImageURL(FlikerTestObj)
        
        XCTAssertEqual(testableUrl?.absoluteString, "http://farm5.static.flickr.com/4740/39593986652_0ec416669f.jpg")
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSimpleApi() {
        self.viewModel?.refreshResults(query: "kitten", page: 1)
        XCTAssert(self.viewModel?.flickerObjectList.value.count == 2)
        XCTAssert(self.viewModel?.flickerObjectList.value.first!.farm == 2)
        XCTAssert(self.viewModel?.flickerObjectList.value.first!.id == "41463558795")
        XCTAssert(self.viewModel?.flickerObjectList.value.first!.owner == "12208635@N07")
        XCTAssert(self.viewModel?.flickerObjectList.value.first!.title == "Every Kitten Wants to Rule the World :-)")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
