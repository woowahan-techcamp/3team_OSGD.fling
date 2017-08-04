//
//  flingUITests.swift
//  flingUITests
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 osgd. All rights reserved.
//

import XCTest

class FlingUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
