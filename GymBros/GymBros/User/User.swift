//
//  User.swift
//  GymBros
//
//  Created by Dylan Schwartz on 12/2/18.
//  Copyright © 2018 Carnegie Mellon University IS Dept. All rights reserved.
//

import Foundation

class User: NSObject {
  
  // MARK: - Properties
  var first_name: String?
  var last_name: String?
  var age: Int?
  var gender: String?
  var email: String?
  
  // Mark: - General
  
  init(first_name: String?, last_name: String?, age: Int?, gender: String?, email: String?){
    super.init()
    self.first_name = first_name
    self.last_name = last_name
    self.age = age
    self.gender = gender
    self.email = email
  }
  
  func name() -> String? {
    if first_name == nil || last_name == nil {
      return nil
    }
    else {
      return first_name! + " " + last_name!
    }
  }
  
  func proper_name() -> String? {
    if first_name == nil || last_name == nil {
      return nil
    }
    else {
      return last_name! + ", " + first_name!
    }
  }
  
}
