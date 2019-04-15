//
//  Dictionary+SortingTests.swift
//  ecommerce-demoTests
//
//  Created by Jason Koo on 12/26/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import XCTest

class Dictionary_SortingTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSmoke() {
        let dictionary = ["c":"cValue",
                          "a":"aValue",
                          "b":"bValue"]
        let expectedResult = [("a", "aValue"),
                              ("b", "bValue"),
                              ("c", "cValue")]
        
        let result = dictionary.asSortedTupleArray()
        XCTAssert(result[0].0 == expectedResult[0].0, "Result found: \(result as AnyObject)")
        XCTAssert(result[0].1 == expectedResult[0].1, "Result found: \(result as AnyObject)")
        XCTAssert(result[2].0 == expectedResult[2].0, "Result found: \(result as AnyObject)")
        XCTAssert(result[2].1 == expectedResult[2].1, "Result found: \(result as AnyObject)")
    }

}
