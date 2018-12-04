//
//  ShowViewController.swift
//  GymBros
//

import UIKit
import Alamofire
import SwiftyJSON

class WorkoutShowViewController: UIViewController {
  
  @IBOutlet var time: UILabel!
  @IBOutlet var location: UILabel!
  @IBOutlet var size: UILabel!
  @IBOutlet var workoutActionButton: UIButton!

  var workout_id: Int?
  var workout: Workout?
  var request = Request()
  var childTableController: JoinedWorkoutTableViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    request.loadUser()
    self.alamoRequest();
    Timer.scheduledTimer(timeInterval: 5, target: self,selector: #selector(WorkoutShowViewController.alamoRequest), userInfo: nil, repeats: true)
  }
  
  
  // Function for the workoutActioButton
  // Case "Join" - Joins the workout
  // Case "Finalize" - For the host only, finalizes the workout so it can't be edited
  // Case "Accept - For the user only, accepts changed workout details
  @IBAction func workoutAction() {
      switch(self.workoutActionButton.currentTitle) {
      case "Join":
          let parameters: Parameters = [
            "workout_id": self.workout!.id!,
            "user_id": self.request.user_id!
          ]
          
          Alamofire.request("https://cryptic-temple-10365.herokuapp.com/joined_workouts", method: .post, parameters: parameters)
              .validate(statusCode: 200..<300)
              .responseJSON { response in
              print("Request: \(String(describing: response.request))")   // original url request
              print("Response: \(String(describing: response.response))") // http url response
              print("Result: \(response.result)")                         // response serialization result
              
              if let json = response.result.value {
                  print("JSON: \(json)") // serialized json response
                  let swiftyjson = JSON(json)
                  self.workoutActionButton.setTitle("Accept", for: .normal)
              }
          };
          break;
      case "Finalize":
          break;
      case "Accept":
          break;
      default:
          break;
      }
  }
  
  // Function to fetch the workout information from the API
  @objc func alamoRequest() {
    Alamofire.request("https://cryptic-temple-10365.herokuapp.com/workouts/\(self.workout_id!)/\(self.request.user_id!)").responseJSON { response in
      print("Request: \(String(describing: response.request))")   // original url request
      print("Response: \(String(describing: response.response))") // http url response
      print("Result: \(response.result)")                         // response serialization result
      
      if let json = response.result.value {
        
        print("JSON: \(json)") // serialized json response
        let swiftyjson = JSON(json)
        
        // Create a workout instance
        self.workout = Workout(swiftyjson: swiftyjson)
        
        // Setting appropriate labels
        self.setLabels()
        self.setButton()
        
        // Sending correcrt data for JoinedWorkouts
        self.childTableController?.workout = self.workout!
        self.childTableController?.tableView.reloadData()
        
      }
    };
  }
  
  // Function to set appropriate labels and propagate joinedWorkouts
  func setLabels(){
    
    // Setting label information
    self.navigationItem.title = self.workout!.title!
    self.time.text = self.workout!.time!
    self.location.text = self.workout!.location!
    self.size.text = String(self.workout!.teamSize!)
  
  }

  // Function to display the correct type of workout action button depending on status
  func setButton() {
      if self.workout!.isOwner(user_id: self.request.user_id!) {
          self.workoutActionButton.setTitle("Finalize", for: .normal)
      }
      else {
          if self.workout!.hasJoined(user_id: self.request.user_id!) {
            if self.workout!.hasBeenAccepted(user_id: self.request.user_id!){
              self.workoutActionButton.setTitle("Accept", for: .normal)
            }
            else {
              self.workoutActionButton.setTitle("Pending", for: .normal)
              self.workoutActionButton.isEnabled = false
            }
          }
          else {
              self.workoutActionButton.setTitle("Join", for: .normal)
          }
      }
  }
  
  // Preparation for the table view cell
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Making reference to childTableController
    if let joinedWorkoutTVC = segue.destination as? JoinedWorkoutTableViewController {
      self.childTableController = joinedWorkoutTVC
    }
    else if let workoutEditVC = segue.destination as? WorkoutEditViewController {
      workoutEditVC.workout = self.workout!
    }
  }

}
