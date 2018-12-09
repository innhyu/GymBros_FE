//
//  GymBrosTests.swift
//  GymBrosTests
//
//  Created by 이인혁 on 09/12/2018.
//  Copyright © 2018 Carnegie Mellon University IS Dept. All rights reserved.
//

import XCTest
import SwiftyJSON

class GymBrosTests: XCTestCase {
    var json: JSON?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "sample", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSON(data: data)
                self.json = jsonResult;
            } catch {
                // handle error
            }
        }
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
    
}
