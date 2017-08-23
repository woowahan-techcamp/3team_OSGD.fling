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

    func testStorageFridge() {
        //save
        var fridge = Refrigerator()

        fridge.add(material: Material.init(mid: 2, name: "우유식빵"))
        fridge.add(material: Material.init(mid: 5, name: "브로콜리"))
        fridge.add(material: Material.init(mid: 3, name: "참치"))

        let storage = Storage()

        storage.saveFridge(fridge: fridge)

        XCTAssertTrue((UserDefaults.standard.array(forKey: "myFridge")?.count)! > 0)

        //load
        fridge = Refrigerator()

        fridge = storage.loadFridge()

        XCTAssertTrue(fridge.materials[0].name == "우유식빵")

    }
}
