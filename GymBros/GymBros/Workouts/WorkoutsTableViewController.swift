//
//  WorkoutsTableViewController.swift
//  GymBros
//

import UIKit
import Alamofire
import SwiftyJSON

class WorkoutsTableViewController: UITableViewController {
    // Saving workout title, time, location, and id
    var workouts = [(title: String, time: String, location: String, id: Int)]()
    
    // The request object used for loading authentication data
    var request = Request()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let formatter = DateFormatter()
        
        // Do any additional setup after loading the view, typically from a nib.
        // Fetch all workouts from the API
        Alamofire.request("https://cryptic-temple-10365.herokuapp.com/workouts").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result

            if let json = response.result.value {
              
              print("JSON: \(json)") // serialized json response
              let swiftyjson = JSON(json)
              if swiftyjson.count > 0 {
                self.workouts = []
                for workout in swiftyjson.arrayValue {
                    let title = workout["title"].string!
                    let id = workout["id"].int!
                    
                    // Turning API date string into Date object
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
                    let date = formatter.date(from: workout["time"].string!)
                    // Formatting date appropriately
                    formatter.dateFormat = "MMM dd, HH:mm"
                    let time = formatter.string(from: date!)
                    
                    let location = workout["location"].string!
                    self.workouts.append((title: title, time: time, location: location, id: id))
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
        cell.title?.text = workout.title
        cell.location?.text = workout.location
        cell.time?.text = workout.time
        return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      print(indexPath)
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
