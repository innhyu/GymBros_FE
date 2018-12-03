//
//  Workouts.swift
//  GymBros
//

import Foundation

class Workout: NSObject {
  
  // MARK: - Properties
  var title: String?
  var time: String?
  var duration: Int?
  var location: String?
  var teamSize: Int?
  var user_id: Int?
  
  // Mark: - General
  
  init(title: String?, time: String?, duration: Int?, location: String?, teamSize: Int?, user_id: Int?){
    super.init()
    self.title = title
    self.time = time
    self.duration = duration
    self.location = location
    self.teamSize = teamSize
    self.user_id = user_id
  }
  
  func valid() -> Bool {
    if self.title == nil || self.time == nil || self.duration == nil || self.location == nil || self.teamSize == nil || user_id == nil {
      return false
    }
    else {
      return true
    }
  }
}
