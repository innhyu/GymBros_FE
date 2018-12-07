//
//  WorkoutEditViewController.swift
//  GymBros
//

import UIKit

class WorkoutEditViewController: UIViewController {
  //Mark: - Properties
  var workout: Workout?
  
  @IBOutlet weak var workoutTitle: UITextField!
  @IBOutlet weak var workoutTime: UITextField!
  @IBOutlet weak var workoutDuration: UITextField!
  @IBOutlet weak var workoutLocation: UITextField!
  @IBOutlet weak var teamSize: UITextField!
  
  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
      self.navigationItem.title = "Edit Workout"
    
      self.workoutTitle.text = self.workout!.title!
      self.workoutTime.text = self.workout!.time!
      self.workoutDuration.text = String(self.workout!.duration!)
      self.workoutLocation.text = self.workout!.location!
      self.teamSize.text = String(self.workout!.teamSize!)
    
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
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
