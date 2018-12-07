//
//  WorkoutsTableViewController.swift
//  GymBros
//

import UIKit
import Alamofire
import SwiftyJSON

class WorkoutsTableViewController: UITableViewController {
    // Saving workout title, time, location, and id
    var workouts = [[Workout]]()
    var sectionTitles = ["My Workouts", "All Workouts"]
    var request = Request()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.request.loadUser()
      
        // Do any additional setup after loading the view, typically from a nib.
        // Fetch all workouts from the API
        Alamofire.request("https://cryptic-temple-10365.herokuapp.com/workouts/\(request.user_id!)").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result

            if let json = response.result.value {
              
              print("JSON: \(json)") // serialized json response
              let swiftyjson = JSON(json)
              
              let myWorkouts = swiftyjson["user_workouts"]
              let otherWorkouts = swiftyjson["other_workouts"]
          
              self.workouts.append(self.populateWorkouts(swiftyjson: myWorkouts))
              self.workouts.append(self.populateWorkouts(swiftyjson: otherWorkouts))
              
              self.tableView.reloadData()

          
          }
        }
    }
  
    override func numberOfSections(in tableView: UITableView) -> Int {
      return self.workouts.count
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.workouts[section].count
    }
  
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      return self.sectionTitles[section]
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as! WorkoutTableViewCell
      let workout = workouts[indexPath.section][indexPath.row]
      cell.title?.text = workout.title!
      cell.location?.text = workout.location!
      cell.time?.text = workout.time!
      
      if workout.isOwner(user_id: request.user_id!) {
          cell.moreInfo?.text = "• My Workout    "
      }
      else {
          cell.moreInfo?.text = ""
      }
      
      if workout.finalized! {
        cell.moreInfo?.text = cell.moreInfo!.text! + "• Finalized"
      }
      else {
        cell.moreInfo?.text = cell.moreInfo!.text! + "• Waiting"
      }
      
      return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      performSegue(withIdentifier: "toShowPage", sender: indexPath)
    }
  
    // Function to parse through the workouts and return the [Workout] object
    func populateWorkouts(swiftyjson: JSON) -> [Workout] {
      var workouts = [Workout]()
      for json in swiftyjson.arrayValue {
        // Since Workout model expects to parse a json with key "workout", setting it here
        let workout = Workout(swiftyjson: ["workout": json])
        workouts.append(workout)
      }
      return workouts
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if (segue.identifier == "toShowPage") {
        if let destNavController = segue.destination as? UINavigationController{
          if let destVC = destNavController.topViewController as? WorkoutShowViewController{
            let index = sender as! IndexPath
            // Fetch the id for that specific workout
            destVC.workout_id = self.workouts[index.section][index.row].id
          }
        }
      }
    }
  
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }

}
