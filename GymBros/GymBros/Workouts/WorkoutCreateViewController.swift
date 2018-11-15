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

class WorkoutCreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  let locations = ["Wiegand Gymnasium", "Jared L. Cohon Center Gymnasium", "Skibo Gymnasium"]
  
  @IBOutlet weak var workoutTitle: UITextField!
  @IBOutlet weak var workoutTime: UITextField!
  @IBOutlet weak var workoutDuration: UITextField!
  @IBOutlet weak var workoutLocation: UITextField!
  @IBOutlet weak var workoutType: UITextField!
  @IBOutlet weak var teamSize: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    let locationPicker = UIPickerView()
    workoutLocation.inputView = locationPicker
    locationPicker.delegate = self
    workoutLocation.text = locations[0]
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.locations.count
  }
  
  func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return self.locations[row]
  }
  
  func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    workoutLocation.text = self.locations[row]
    self.view.endEditing(true)
  }
  
  @IBAction func createWorkout(_ sender: Any){
    // Fetching fields from the inputs
    let title = self.workoutTitle.text;
    let time = self.workoutTime.text;
    let duration: Int? = Int(self.workoutDuration.text!);
    let location = self.workoutLocation.text;
    // Type isn't used yet
    // let type = self.workoutType.text;
    let teamSize: Int? = Int(self.teamSize.text!);

    // Constructing parameter needed for Alamofire Request
    let parameters: Parameters = [
      // TODO: Do something with user_id
      "user_id": 1,
      "title": title ?? "",
      "time": time ?? "", // "Format is in -> 2007-12-04 00:00:00 -0000"
      "duration": duration ?? "",
      // Do something with location to make a dropdown
      "location": location ?? "",
      "team_size": teamSize ?? ""
    ]

    // Making Alamofire request
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
      else {
        // Alert to show that the workout create failed to the user.
        let fail = UIAlertController(title: "Alert", message: "Workout create failed. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
        fail.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(fail, animated: true, completion: nil)
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
