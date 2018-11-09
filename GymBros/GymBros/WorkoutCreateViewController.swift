//
//  WorkoutCreateViewController.swift
//  GymBros
//
//  Created by 이인혁 on 08/11/2018.
//  Copyright © 2018 Carnegie Mellon University IS Dept. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WorkoutCreateViewController: UIViewController {

  @IBOutlet weak var workoutTitle: UITextField!
  @IBOutlet weak var workoutTime: UITextField!
  @IBOutlet weak var workoutDuration: UITextField!
  @IBOutlet weak var workoutLocation: UITextField!
  @IBOutlet weak var workoutType: UITextField!
  @IBOutlet weak var teamSize: UITextField!
  
  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  @IBAction func createWorkout(_ sender: Any){
    let title = self.workoutTitle.text;
    let time = self.workoutTime.text;
    let duration: Int? = Int(self.workoutDuration.text!);
    let location = self.workoutLocation.text;
    let type = self.workoutType.text;
    let teamSize: Int? = Int(self.teamSize.text!);

    let parameters: Parameters = [
      "user_id": 1,
      "title": title ?? nil,
      "time": time, // "2007-12-04 00:00:00 -0000"
      "duration": duration ?? nil,
      "location": "WIEGAND GYMNASIUM",
      "team_size": teamSize ?? nil
    ]

    Alamofire.request("https://cryptic-temple-10365.herokuapp.com/workouts", method: .post, parameters: parameters)
    .validate(statusCode: 200..<300)
    .responseJSON { response in
      print("Request: \(String(describing: response.request))")   // original url request
      print("Response: \(String(describing: response.response))") // http url response
      print("Result: \(response.result)")                         // response serialization result

      if let json = response.result.value {

        print("JSON: \(json)") // serialized json response
        let swiftyjson = JSON(json);
        print(swiftyjson)
        print(swiftyjson["location"])
        self.performSegue(withIdentifier: "workoutCreated", sender: sender)
      }
    }
    
  }
  

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
