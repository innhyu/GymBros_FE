//
//  WorkoutsTableViewController.swift
//  GymBros
//

import UIKit
import Alamofire
import SwiftyJSON

class WorkoutsTableViewController: UITableViewController {
    // Saving workout title, time, location, and id
    var workouts = [Workout]()
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
              
              if !swiftyjson.isEmpty {
                // Construct workout object for each
                for swiftyjson in swiftyjson.arrayValue {
                  let workout = Workout(swiftyjson: ["workout": swiftyjson])
                    self.workouts.append(workout)
                }
                
                self.tableView.reloadData()
                
              }
            }
        }
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return workouts.count
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as! WorkoutTableViewCell
      let workout = workouts[indexPath.row]
      cell.title?.text = workout.title!
      cell.location?.text = workout.location!
      cell.time?.text = workout.time!
      return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      performSegue(withIdentifier: "toShowPage", sender: indexPath)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if (segue.identifier == "toShowPage") {
        if let destNavController = segue.destination as? UINavigationController{
          if let destVC = destNavController.topViewController as? WorkoutShowViewController{
            let index = sender as! IndexPath
            // Fetch the id for that specific workout
            destVC.workout_id = self.workouts[index.row].id
          }
        }
      }
    }
  
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }

}
