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
  @IBOutlet var workoutEditButton: UIButton!

  var workout_id: Int?
  var workout: Workout?
  var joinedWorkout: JoinedWorkout?
  var request = Request()
  var childTableController: JoinedWorkoutTableViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.request.loadUser()
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
                self.workoutActionButton.setTitle("Pending", for: .normal)
                self.workoutActionButton.isEnabled = false
                self.alamoRequest();
              }
              else {
                // Alert to show that the checkin failed.
                let fail = UIAlertController(title: "Failed", message: "Failed to join workout. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                fail.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(fail, animated: true, completion: nil)
              }
          };
          break;
      case "Finalize":
          Alamofire.request("https://cryptic-temple-10365.herokuapp.com/workouts/\(self.workout_id!)/finalize", method: .patch)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
              
              print("JSON: \(json)") // serialized json response
              let swiftyjson = JSON(json)
              
              // Fire the alamorequest so the entire new finalize can be fetched
              self.alamoRequest();
              // Showing the alert that tells workout finalize was successful
              let success = UIAlertController(title: "Success", message: "Workout finalized!", preferredStyle: UIAlertControllerStyle.alert)
              success.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
              self.present(success, animated: true, completion: nil)
            }
            else {
              // Alert to show that the checkin failed.
              let fail = UIAlertController(title: "Failed", message: "Workout finalize failed. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
              fail.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
              self.present(fail, animated: true, completion: nil)
            }
          };
          break;
      case "Approve":
          Alamofire.request("https://cryptic-temple-10365.herokuapp.com/joined_workouts/\(self.joinedWorkout!.id!)/approve", method: .patch)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
              
              print("JSON: \(json)") // serialized json response
              let swiftyjson = JSON(json)
              
              // Fire the alamorequest so the entire new finalize can be fetched
              self.alamoRequest();
            }
            else {
              // Alert to show that the checkin failed.
              let fail = UIAlertController(title: "Failed", message: "Failed to approve workout changes. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
              // Avoiding weird snapshot errors; from stackoverflow
              fail.view.layoutIfNeeded()
              fail.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
              self.present(fail, animated: true, completion: nil)
            }
          };
          break;
      case "Check-In":
          performSegue(withIdentifier: "checkIn", sender: self);
          break;
      default:
          break;
      }
  }
  
  // Function to fetch the workout information from the API
  @objc func alamoRequest() {
    Alamofire.request("https://cryptic-temple-10365.herokuapp.com/workouts/\(self.workout_id!)/\(self.request.user_id!)")
      .validate(statusCode: 200..<300)
      .responseJSON { response in
      print("Request: \(String(describing: response.request))")   // original url request
      print("Response: \(String(describing: response.response))") // http url response
      print("Result: \(response.result)")                         // response serialization result
      
      if let json = response.result.value {
        
        print("JSON: \(json)") // serialized json response
        let swiftyjson = JSON(json)
        
        // Create a workout instance
        self.workout = Workout(swiftyjson: swiftyjson)
        self.joinedWorkout = self.workout!.joinedWorkoutOf(user_id: self.request.user_id!)
        
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
      if self.workout!.finalized! {
        self.workoutActionButton.setTitle("Check-In", for: .normal)
        self.workoutActionButton.isEnabled = true
        self.workoutEditButton.isEnabled = false
        
        if self.joinedWorkout!.checked_in! {
          self.workoutActionButton.setTitleColor(UIColor(red: 128/255, green: 232/255, blue: 38/255, alpha: 1), for: [])
        }
        else {
          self.workoutActionButton.setTitleColor(UIColor(red: 255/255, green: 240/255, blue: 25/255, alpha: 1), for: [])
        }
        
      }
      else if self.workout!.isOwner(user_id: self.request.user_id!) {
        self.workoutActionButton.setTitle("Finalize", for: .normal)
        self.workoutEditButton.isEnabled = true
        self.workoutActionButton.isEnabled = true
      }
      else {
        if self.workout!.hasJoined(user_id: self.request.user_id!) {
          if self.workout!.hasBeenAccepted(user_id: self.request.user_id!){
            
            if joinedWorkout!.approved! {
              self.workoutActionButton.setTitleColor(UIColor(red: 128/255, green: 232/255, blue: 38/255, alpha: 1), for: [])
            }
            else {
              self.workoutActionButton.setTitleColor(UIColor(red: 255/255, green: 240/255, blue: 25/255, alpha: 1), for: [])
            }
            self.workoutActionButton.setTitle("Approve", for: .normal)
            self.workoutActionButton.isEnabled = true
          }
          else {
            self.workoutActionButton.setTitle("Pending", for: .normal)
            self.workoutActionButton.isEnabled = false
          }
        }
        else {
            self.workoutActionButton.setTitle("Join", for: .normal)
            self.workoutActionButton.isEnabled = true
        }
        self.workoutEditButton.isEnabled = false;
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
    else if let checkinVC = segue.destination as? CheckInViewController {
      checkinVC.check_in_code = self.workout!.check_in_code!
      checkinVC.joinedWorkout = self.joinedWorkout
    }
  }

}
