//
//  ShowViewController.swift
//  GymBros
//

import UIKit
import Alamofire
import SwiftyJSON

class WorkoutShowViewController: UIViewController {
  
    @IBOutlet var ownerName: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var size: UILabel!
    @IBOutlet var workoutActionButton: UIButton!

    var workout_id: Int?
    var owner_id: Int = 0
    var request = Request()
    var childTableController: JoinedWorkoutTableViewController?
    var joinedWorkouts = [(username: String, status: Int, id: Int)]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request.loadUser()
        
        let formatter = DateFormatter()
        
        Alamofire.request("https://cryptic-temple-10365.herokuapp.com/workouts/\(workout_id!)/\(request.user_id!)").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
          
            if let json = response.result.value {
            
                print("JSON: \(json)") // serialized json response
                let swiftyjson = JSON(json)
                print(self.navigationItem.title)
                self.navigationItem.title = swiftyjson["workout"]["title"].string!
                
                print(self.navigationItem.title)
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
                let fullOwnerName = "\(swiftyjson["owner"]["first_name"].string!) \(swiftyjson["owner"]["last_name"].string!)"
                self.ownerName.text = fullOwnerName
                
                // JoinedWorkout parsing section
                let allJoinedWorkouts = swiftyjson["joined_workouts"].array!
                allJoinedWorkouts.forEach { joinedWorkout in
                    let info = joinedWorkout[0]
                    let status = info["accepted"].int!
                    let joinedWorkout_id = info["id"].int!
                    let user = joinedWorkout[1]
                    let name = "\(user["first_name"].string!) \(user["last_name"].string!)"
                    self.joinedWorkouts.append((name, status, joinedWorkout_id))
                }
                
                self.childTableController?.joinedWorkouts = self.joinedWorkouts
                self.childTableController?.tableView.reloadData()
            }
        };
        
    }
    
    
    // Function for the workoutActioButton
    // Case "Join" - Joins the workout
    // Case "Finalize" - For the host only, finalizes the workout so it can't be edited
    // Case "Accept - For the user only, accepts changed workout details
    @IBAction func workoutAction() {
        switch(self.workoutActionButton.currentTitle) {
        case "Join":
            let parameters: Parameters = [
                "workout_id": self.workout_id!,
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
    
    // Function to display the correct type of workout action button depending on status
    func setButton(swiftyjson: JSON) {
        if self.isOwner(jsondata: swiftyjson, user_id: self.request.user_id!) {
            self.workoutActionButton.setTitle("Finalize", for: .normal)
        }
        else {
            if self.hasJoined(jsondata: swiftyjson, user_id: self.request.user_id!) {
                self.workoutActionButton.setTitle("Accept", for: .normal)
            }
            else {
                self.workoutActionButton.setTitle("Join", for: .normal)
            }
        }
    }
    
    // Function to check if from the returned json data that the current user is in the workout
    func hasJoined(jsondata: JSON, user_id: Int) -> Bool {
        let joined_workouts_users = jsondata["joined_workouts"]
        for jwu in joined_workouts_users{
            let (_, swiftyjson) = jwu
            let joined_workout = swiftyjson[0]
            if let joined_user_id = joined_workout["user_id"].int {
                if joined_user_id == user_id {
                    return true
                }
            }
        }
        return false
    }
    
    // Function to check if
    func isOwner(jsondata: JSON, user_id: Int) -> Bool {
        let owner = jsondata["owner"]
        if let owner_id = owner["id"].int {
            if owner_id == user_id {
                return true
            }
        }
        return false
    }
    
    // Preparation for the table view cell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? JoinedWorkoutTableViewController {
            self.childTableController = destination
        }
    }
  
}
