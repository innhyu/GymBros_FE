//
//  CheckInViewController.swift
//  GymBros
//
//  Created by 이인혁 on 07/12/2018.
//  Copyright © 2018 Carnegie Mellon University IS Dept. All rights reserved.
//

import UIKit

class CheckInViewController: UIViewController {

    // Mark: - Properties
    var check_in_code: Int?
    var workout: Workout?
    var request = Request()

    @IBOutlet weak var check_in_input: UITextField!
    @IBOutlet weak var check_in_button: UIButton!
    @IBOutlet weak var helper_text: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        request.loadUser();
      
        // Do any additional setup after loading the view.
      
        // Case Owner: Populate check-in code
        if self.workout!.isOwner(user_id: request.user_id!){
          self.check_in_input.text = String(self.check_in_code!)
        }
        else {
          self.check_in_input.text = ""
          self.check_in_input.isEnabled = true
          self.check_in_button.isEnabled = true
          self.helper_text.text = "Get the check-in code from the workout session host when you meet them in the designated location!"
        }
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
