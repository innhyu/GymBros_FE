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
        cell.setOwner();
      }
      else if joinedWorkout.accepted! {
        cell.setMember();
      }
      else {
        cell.setPending();
      }
      cell.user_id = joinedWorkout.user_id!
      cell.parentTableController? = self
      cell.id = joinedWorkout.id!
      

      // Not showing accept / decline button unless user is an owner
      if !(workout.isOwner(user_id: request.user_id!)){
        cell.acceptButton.isHidden = true
        cell.declineButton.isHidden = true
      }

    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "showUser", sender: indexPath)
  }

  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let profileVC = segue.destination as? ProfileViewController {
        let indexPath = sender as! IndexPath
        profileVC.user_id = self.workout!.joined_workouts[indexPath.row].user_id!
      }
  }

}
