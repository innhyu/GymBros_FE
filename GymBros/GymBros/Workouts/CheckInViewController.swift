//
//  CheckInViewController.swift
//  GymBros
//
//  Created by 이인혁 on 07/12/2018.
//  Copyright © 2018 Carnegie Mellon University IS Dept. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CheckInViewController: UIViewController {

    // Mark: - Properties
    var check_in_code: Int?
    var joinedWorkout: JoinedWorkout?
    var request = Request()

    @IBOutlet weak var check_in_input: UITextField!
    @IBOutlet weak var check_in_button: UIButton!
    @IBOutlet weak var helper_text: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        request.loadUser();
      
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Check In"
      
        // Case Owner: Populate check-in code
        if self.joinedWorkout!.is_owner! {
          self.check_in_input.text = String(self.check_in_code!)
        }
        else {
          self.check_in_input.text = ""
          self.check_in_input.isEnabled = true
          self.check_in_button.isEnabled = true
          self.helper_text.text = "Get the check-in code from the workout session host when you meet them in the designated location!"
        }
    }
  
    // Function to check the user in
    @IBAction func check_in_user() {
      let parameters: Parameters = [
        "check_in_code": self.check_in_input.text ??  ""
      ]
      
      Alamofire.request("https://cryptic-temple-10365.herokuapp.com/joined_workouts/\(self.joinedWorkout!.id!)/check_in", method: .patch, parameters: parameters)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
        print("Request: \(String(describing: response.request))")   // original url request
        print("Response: \(String(describing: response.response))") // http url response
        print("Result: \(response.result)")                         // response serialization result
        
        if let json = response.result.value {
          
          print("JSON: \(json)") // serialized json response
          let swiftyjson = JSON(json)
          
          // Showing the alert that tells user check-in was successful
          // SIDE: Popping back to the login screen
          let success = UIAlertController(title: "Success", message: "Checked-in! Enjoy your workout!", preferredStyle: UIAlertControllerStyle.alert)
          success.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.navigationController?.popViewController(animated: true)
          }))
          self.present(success, animated: true, completion: nil)
        }
        else {
          // Alert to show that the checkin failed.
          let fail = UIAlertController(title: "Failed", message: "Check-in failed. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
          fail.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
          self.present(fail, animated: true, completion: nil)
        }
      };
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
