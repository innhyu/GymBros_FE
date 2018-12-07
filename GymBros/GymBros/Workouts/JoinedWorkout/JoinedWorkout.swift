//
//  JoinedWorkout.swift
//  GymBros
//

import Foundation
import SwiftyJSON

class JoinedWorkout {
  
  //MARK: - Properties
  var id: Int?
  var user_id: Int?
  var full_name: String?
  var accepted: Bool?
  var approved: Bool?
  var checked_in: Bool?
  var is_owner: Bool?
  
  //MARK: - Initialization
  init(swiftyjsonArray: JSON){
    // Info section of joined_workout
    let info = swiftyjsonArray[0]
    self.accepted = info["accepted"].bool!
    self.approved = info["approved"].bool!
    self.checked_in = info["checked_in"].bool!
    self.id = info["id"].int!
    self.user_id = info["user_id"].int!
    
    // User section of joined_workout
    let user = swiftyjsonArray[1]
    self.full_name = "\(user["first_name"].string!) \(user["last_name"].string!)"
  }
  
}
