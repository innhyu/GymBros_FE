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
  
  //    TODO: Merge this into an init function
  func setup(title: String, time: String, duration: Int, location: String, teamSize: Int, user_id: Int) {
    self.title = title
    self.time = time
    self.duration = duration
    self.location = location
    self.teamSize = teamSize
    self.user_id = user_id
  }
  
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
    
    return false
  }
}
