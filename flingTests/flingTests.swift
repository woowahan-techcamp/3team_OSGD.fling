//
//  flingTests.swift
//  flingTests
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 osgd. All rights reserved.
//

import XCTest
@testable import fling

class FlingTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testCheckUrl() {
        let controller = HomeViewController()
        
        XCTAssertTrue(controller.checkRecipeUrl(url: "http://haemukja.com/recipes/49"))
    }
    
    func testProduct() {
        let temp = [
            ["id": 11, "material_id": 1, "name": "삼원농산 영양듬뿍 잡곡 귀리", "price": "5700", "weight": "5kg", "bundle": "1개", "image": "t5a.coupangcdn.comthumbnailsremote292x292eximageproductimagevendoritem201604193000580651036da747-80bb-40d8-9285-0f78f3dcaf50.jpg"],
            ["id": 22, "material_id": 2, "name": "순수담 귀리볶음가루", "price": "10000", "weight": "1kg", "bundle": "1개", "image": "t1c.coupangcdn.comthumbnailsremote292x292eximageretailimages20160422182aab0317e-1cee-422b-bd46-9661393d3e17.JPG"],
            ["id": 33, "material_id": 3, "name": "오뚜기 옛날 구수한 누룽지", "price": "14900", "weight": "3kg", "bundle": "1개", "image": "t2a.coupangcdn.comthumbnailsremote292x292eximageproductimagevendoritem201605173011864835d34b6acd-6756-4838-bee5-1094f3843f46.jpg"]
        ]
        
        let product = Product.init(data: temp[0])
        let predict = temp[0]["name"] as? String
        
        XCTAssertTrue(product?.getName() == predict)
    }
}
