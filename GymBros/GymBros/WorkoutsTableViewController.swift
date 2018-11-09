//
//  WorkoutsTableViewController.swift
//  GymBros
//
//  Created by 이인혁 on 08/11/2018.
//  Copyright © 2018 Carnegie Mellon University IS Dept. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WorkoutsTableViewController: UITableViewController {
    var workouts = [String]()
  
    override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      //get workouts from api
      self.workouts = ["workout1", "workout2"]
      Alamofire.request("https://cryptic-temple-10365.herokuapp.com/workouts").responseJSON { response in
        print("Request: \(String(describing: response.request))")   // original url request
        print("Response: \(String(describing: response.response))") // http url response
        print("Result: \(response.result)")                         // response serialization result
        
        if let json = response.result.value {
          
          print("JSON: \(json)") // serialized json response
          let swiftyjson = JSON(json)
          print(swiftyjson[0])
          if swiftyjson.count > 0 {
            self.workouts = []
            for workout in swiftyjson.arrayValue {
              self.workouts.append(workout["title"].string!)
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
      let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath)
      cell.textLabel?.text = workouts[indexPath.row]
      return cell
    }
  
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
