//
//  RegisterViewController.swift
//  GymBros
//
//  Created by 이인혁 on 09/11/2018.
//  Copyright © 2018 Carnegie Mellon University IS Dept. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController {
  @IBOutlet weak var userEmail: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var passwordConfirmation: UITextField!
  @IBOutlet weak var firstName: UITextField!
  @IBOutlet weak var lastName: UITextField!
  @IBOutlet weak var gender: UITextField!
  @IBOutlet weak var age: UITextField!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func register() {
    let email: String? = self.userEmail.text
    let password: String? = self.password.text
    let passwordConfirmation: String? = self.passwordConfirmation.text
    let firstName: String? = self.firstName.text
    let lastName: String? = self.lastName.text
    let gender: String? = self.gender.text
    let age: Int? = Int(self.age.text ?? "")
    
    let parameters: Parameters = [
      "email": email ?? "",
      "password": password ?? "",
      "passwordConfirmation": passwordConfirmation ?? nil,
      "role": "Real",
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
      "age": age ?? nil,
    ]
    
    
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
