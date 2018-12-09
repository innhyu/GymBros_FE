//
//  GymBrosTests.swift
//  GymBrosTests
//
//

import XCTest
import SwiftyJSON
@testable import GymBros

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
    
    func testParser() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        print("\nStart Parser Test ---------- \n")
        let workout = Workout(swiftyjson: self.json!)

        XCTAssert(1 == workout.id!)
        XCTAssert(1 == workout.owner_id!)
        XCTAssert("My Leg Workout" == workout.title!)
        // Skipping formatting validation for time because it's formatted differently
        XCTAssertNotNil(workout.time)
        XCTAssert(180 == workout.duration!)
        XCTAssert("WIEGAND GYMNASIUM" == workout.location!)
        XCTAssert(3 == workout.teamSize!)
        XCTAssertTrue(workout.finalized!)
        XCTAssert("Andy Lee" == workout.owner_name!)
        XCTAssert(2 == workout.joined_workouts.count)

        print("\nEnd of Properties Test ----------- \n\n")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
