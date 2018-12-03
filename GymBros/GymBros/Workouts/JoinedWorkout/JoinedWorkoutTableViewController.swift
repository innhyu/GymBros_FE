//
//  JoinedWorkoutTableViewController.swift
//  GymBros
//

import UIKit

class JoinedWorkoutTableViewController: UITableViewController {
  // Mark: - Properties
  var workout: Workout?
  var request = Request()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self
  
    request.loadUser();
  
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let workout = self.workout {
      return workout.joined_workouts.count
    }
    return 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Prepare cell and necessary info
    let cell = tableView.dequeueReusableCell(withIdentifier: "joinedWorkout", for: indexPath) as! JoinedWorkoutTableViewCell

    if let workout = self.workout {
      
      let joinedWorkout = workout.joined_workouts[indexPath.row]
      
      // Setting cell info
      cell.name?.text = joinedWorkout.full_name!
      if joinedWorkout.is_owner! {
        cell.identity.text = "Owner"
        cell.identity.backgroundColor = UIColor(red: 45/255, green: 94/255, blue: 255/255, alpha: 0.5)
      }
      else if joinedWorkout.accepted! {
        cell.identity.text = "Member"
        cell.identity.backgroundColor = UIColor(red: 128/255, green: 232/255, blue: 38/255, alpha: 0.5)
      }
      else {
        cell.identity.text = "Pending"
        cell.identity.backgroundColor = UIColor(red: 212/255, green: 232/255, blue: 226/255, alpha: 1.0)
      }
      cell.user_id = joinedWorkout.user_id!
      cell.parentTableController? = self
      

      // Not showing accept / decline button for accepted users
      
      if (joinedWorkout.accepted)! {
          cell.acceptButton.isHidden = true
          cell.declineButton.isHidden = true
      }
    }
    
    return cell
  }

  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }

}
