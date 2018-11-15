//
//  ShowViewController.swift
//  GymBros
//
//  Created by Dylan Schwartz on 11/9/18.
//  Copyright © 2018 Carnegie Mellon University IS Dept. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WorkoutShowViewController: UIViewController {
  
    @IBOutlet var name: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var size: UILabel!
    @IBOutlet var workoutAction: UIButton!

    var workout_id: Int?
    var owner_id: Int = 0
    var request = Request()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request.loadUser()
        
        let formatter = DateFormatter()
        
        Alamofire.request("https://cryptic-temple-10365.herokuapp.com/workouts/\(workout_id!)").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
          
            if let json = response.result.value {
            
                print("JSON: \(json)") // serialized json response
                let swiftyjson = JSON(json)
                self.name.text = swiftyjson["workout"]["title"].string
                // Turning API date string into Date object
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
                let date = formatter.date(from: swiftyjson["workout"]["time"].string!)
                // Formatting date appropriately
                formatter.dateFormat = "MMM dd, HH:mm"
                self.time.text = formatter.string(from: date!)
            
                self.location.text = swiftyjson["workout"]["location"].string
                //        self.type.text = swiftyjson["workout"]["location"].string // There is no workout type yet;
                self.size.text = String(swiftyjson["workout"]["team_size"].int!)
                
                // Owner parsing section
                self.owner_id = swiftyjson["owner"]["id"].int!
            }
        }
        
        if self.owner_id == request.user_id! {
            workoutAction.setTitle("Finalize", for: .normal)
        }
        else {
            workoutAction.setTitle("Accept", for: .normal)
        }
        
  }
  
// Preparation is done in the table, not this
//  func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
//    if (segue.identifier == "toShowPage") {
//      let index = sender as! IndexPath
//      self.index = index.row
//    }
//  }
  
}
