//
//  WorkoutEditViewController.swift
//  GymBros
//

import UIKit

class WorkoutEditViewController: UIViewController {
  //Mark: - Properties
  var workout: Workout?
  
  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
      self.navigationItem.title = "Edit Workout"
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
