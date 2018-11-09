//
//  WorkoutCreateViewController.swift
//  GymBros
//
//  Created by 이인혁 on 08/11/2018.
//  Copyright © 2018 Carnegie Mellon University IS Dept. All rights reserved.
//

import UIKit
import Alamofire

class WorkoutCreateViewController: UIViewController {

  @IBOutlet weak var workoutTitle: UITextField!
  @IBOutlet weak var workoutTime: UITextField!
  @IBOutlet weak var workoutLocation: UITextField!
  @IBOutlet weak var workoutType: UITextField!
  @IBOutlet weak var teamSize: UITextField!
  
  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  @IBAction func createWorkout(){
    let title = self.workoutTitle.text;
    let time = self.workoutTime.text;
    let location = self.workoutLocation.text;
    let type = self.workoutType.text;
    let teamSize = self.teamSize.text;
    
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
