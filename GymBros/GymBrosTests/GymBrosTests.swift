//
//  GymBrosTests.swift
//  GymBrosTests
//
//

import XCTest
import SwiftyJSON
@testable import GymBros

class GymBrosTests: XCTestCase {
    var json = [JSON]()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        parseJson();
    }
    
    func parseJson(){
        let bundle = Bundle(for: type(of: self))
        for i in 1...2 {
            if let path = bundle.path(forResource: "sample\(i)", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonResult = try JSON(data: data)
                    self.json.append(jsonResult);
                } catch {
                    // handle error
                    print("\n\n\n ERROR \n\n\n")
                }
            }
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParser1() {
        print("\nStart Parser Test 1 ---------- \n")
        let workout = Workout(swiftyjson: self.json[0])

        XCTAssert(1 == workout.id!)
        XCTAssert(1 == workout.owner_id!)
        XCTAssert("My Leg Workout" == workout.title!)
        // Skipping formatting validation for time because it's formatted differently
        XCTAssertNotNil(workout.time)
        XCTAssert(180 == workout.duration!)
        XCTAssert("WIEGAND GYMNASIUM" == workout.location!)
        XCTAssert(3 == workout.teamSize!)
        XCTAssertTrue(workout.finalized!)
        XCTAssertNotNil(workout.check_in_code)
        XCTAssert("Andy Lee" == workout.owner_name!)
        XCTAssert(2 == workout.joined_workouts.count)

        print("\nEnd of Parser Test 1 ----------- \n")
    }
    
    func testParser2() {
        print("\nStart Parser Test 2 ---------- \n")
        let workout = Workout(swiftyjson: self.json[1])
        
        XCTAssert(2 == workout.id!)
        XCTAssert(1 == workout.owner_id!)
        XCTAssert("Workout" == workout.title!)
        // Skipping formatting validation for time because it's formatted differently
        XCTAssertNotNil(workout.time)
        XCTAssert(90 == workout.duration!)
        XCTAssert("WIEGAND GYMNASIUM" == workout.location!)
        XCTAssert(6 == workout.teamSize!)
        XCTAssertFalse(workout.finalized!)
        XCTAssertNil(workout.check_in_code)
        XCTAssert("Andy Lee" == workout.owner_name!)
        XCTAssert(1 == workout.joined_workouts.count)
        
        print("\nEnd of Parser Test 2 ----------- \n")
    }
    
    func testHasJoined() {
        print("\nStart HasJoined Test 1 ---------- \n")

        let workout = Workout(swiftyjson: self.json[0])
        XCTAssertTrue(workout.hasJoined(user_id: 1))
        XCTAssertTrue(workout.hasJoined(user_id: 2))
        XCTAssertFalse(workout.hasJoined(user_id: 3))

        print("\nEnd HasJoined Test 1 ---------- \n")
    }
  
    func testHasJoined2() {
        print("\nStart HasJoined Test 2 ---------- \n")

        let workout = Workout(swiftyjson: self.json[1])
        XCTAssertTrue(workout.hasJoined(user_id: 1))
        XCTAssertFalse(workout.hasJoined(user_id: 2))
        XCTAssertFalse(workout.hasJoined(user_id: 3))

        print("\nEnd HasJoined Test 2 ---------- \n")
    }
  
    func testHasBeenAccepted() {
        print("\nStart HasBeenAccepted Test 1 ---------- \n")
        
        let workout = Workout(swiftyjson: self.json[0])
        XCTAssertTrue(workout.hasBeenAccepted(user_id: 1))
        XCTAssertTrue(workout.hasBeenAccepted(user_id: 2))
        XCTAssertFalse(workout.hasBeenAccepted(user_id: 3))
        
        print("\nEnd HasBeenAccepted Test 1 ---------- \n")
    }
  
    func testHasBeenAccepted2() {
        print("\nStart HasBeenAccepted Test 2 ---------- \n")

        let workout = Workout(swiftyjson: self.json[1])
        XCTAssertTrue(workout.hasBeenAccepted(user_id: 1))
        XCTAssertFalse(workout.hasBeenAccepted(user_id: 2))
        XCTAssertFalse(workout.hasBeenAccepted(user_id: 3))

        print("\nEnd HasBeenAccepted Test 2 ---------- \n")
    }
  
    func testIsOwner() {
        print("\nStart isOwner Test 1 ---------- \n")
        
        let workout = Workout(swiftyjson: self.json[0])
        XCTAssertTrue(workout.isOwner(user_id: 1))
        XCTAssertFalse(workout.isOwner(user_id: 2))
        XCTAssertFalse(workout.isOwner(user_id: 3))
        
        print("\nEnd isOwner Test 1 ---------- \n")
    }
  
    func testIsOwner2() {
        print("\nStart isOwner Test 2 ---------- \n")

        let workout = Workout(swiftyjson: self.json[1])
        XCTAssertTrue(workout.isOwner(user_id: 1))
        XCTAssertFalse(workout.isOwner(user_id: 2))
        XCTAssertFalse(workout.isOwner(user_id: 3))

        print("\nEnd isOwner Test 2 ---------- \n")
    }
  
    func testJoinedWorkoutOf() {
        print("\nStart joinedWorkout Test 1 ---------- \n")
        
        let workout = Workout(swiftyjson: self.json[0])
        XCTAssertTrue(workout.joinedWorkoutOf(user_id: 1) != nil)
        XCTAssertTrue(workout.joinedWorkoutOf(user_id: 2) != nil)
        XCTAssertNil(workout.joinedWorkoutOf(user_id: 3))
        XCTAssertTrue(workout.joinedWorkoutOf(user_id: 1)!.user_id == 1)
        XCTAssertTrue(workout.joinedWorkoutOf(user_id: 2)!.user_id == 2)
        
        print("\nEnd joinedWorkout Test 1 ---------- \n")
    }
  
    func testJoinedWorkoutOf2() {
        print("\nStart joinedWorkout Test 2 ---------- \n")

        let workout = Workout(swiftyjson: self.json[1])
        XCTAssertTrue(workout.joinedWorkoutOf(user_id: 1) != nil)
        XCTAssertNil(workout.joinedWorkoutOf(user_id: 2))
        XCTAssertNil(workout.joinedWorkoutOf(user_id: 3))
        XCTAssertTrue(workout.joinedWorkoutOf(user_id: 1)!.user_id == 1)

        print("\nEnd joinedWorkout Test 2 ---------- \n")
    }
    
    func testIntegration1() {
        print("\nStart Integration Test 1 ---------- \n")
        let workout = Workout(swiftyjson: self.json[0])
    
        let owner = workout.joinedWorkoutOf(user_id: workout.owner_id!)!
        let member = workout.joinedWorkoutOf(user_id: 2)!
        
        XCTAssert(owner.is_owner!)
        XCTAssert(workout.hasJoined(user_id: owner.user_id!))
        XCTAssert(workout.hasBeenAccepted(user_id: owner.user_id!))
        
        XCTAssertFalse(member.is_owner!)
        XCTAssert(workout.hasJoined(user_id: member.user_id!))
        XCTAssert(workout.hasBeenAccepted(user_id: member.user_id!))
            
        print("\nEnd Integration Test 1 ---------- \n")
    }
    
    func testIntegration2() {
        print("\nStart Integration Test 2 ---------- \n")
        let workout = Workout(swiftyjson: self.json[1])
        
        let owner = workout.joinedWorkoutOf(user_id: workout.owner_id!)!
        
        XCTAssert(owner.is_owner!)
        XCTAssert(workout.hasJoined(user_id: owner.user_id!))
        XCTAssert(workout.hasBeenAccepted(user_id: owner.user_id!))
        
        XCTAssertFalse(workout.hasJoined(user_id: 2))
        XCTAssertFalse(workout.hasBeenAccepted(user_id: 2))
        
        print("\nEnd Integration Test 2 ---------- \n")
    }
    
}
