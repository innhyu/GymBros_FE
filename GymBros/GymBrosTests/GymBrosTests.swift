//
//  GymBrosTests.swift
//  GymBrosTests
//
//  Created by 이인혁 on 09/12/2018.
//  Copyright © 2018 Carnegie Mellon University IS Dept. All rights reserved.
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
    
    func testhHasJoined() {
      let workout = Workout(swiftyjson: self.json!)
      XCTAssertTrue(workout.hasJoined(user_id: 1))
      XCTAssertTrue(workout.hasJoined(user_id: 2))
      XCTAssertFalse(workout.hasJoined(user_id: 3))
    }
  
    func testHasBeenAccepted() {
      let workout = Workout(swiftyjson: self.json!)
      XCTAssertTrue(workout.hasBeenAccepted(user_id: 1))
      XCTAssertTrue(workout.hasBeenAccepted(user_id: 2))
      XCTAssertFalse(workout.hasBeenAccepted(user_id: 3))
    }
  
    func testIsOwner() {
      let workout = Workout(swiftyjson: self.json!)
      XCTAssertTrue(workout.isOwner(user_id: 1))
      XCTAssertFalse(workout.isOwner(user_id: 2))
      XCTAssertFalse(workout.isOwner(user_id: 3))
    }
  
    func testJoinedWorkoutOf() {
      let workout = Workout(swiftyjson: self.json!)
      XCTAssertTrue(workout.joinedWorkoutOf(user_id: 1) != nil)
      XCTAssertTrue(workout.joinedWorkoutOf(user_id: 2) != nil)
      XCTAssertNil(workout.joinedWorkoutOf(user_id: 3))
      XCTAssertTrue(workout.joinedWorkoutOf(user_id: 1)!.user_id == 1)
      XCTAssertTrue(workout.joinedWorkoutOf(user_id: 2)!.user_id == 2)
    }
    
}
