//
//  ViewController.swift
//  GymBros
//
//  Created by 이인혁 on 17/09/2018.
//  Copyright © 2018 Carnegie Mellon University IS Dept. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    let request = Request()
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: Any?){
        let parameters: Parameters = [
            "email": emailField.text ?? "",
            "password": passwordField.text ?? ""
        ]
        
        Alamofire.request("https://cryptic-temple-10365.herokuapp.com/login", method: .post, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                
                print("JSON: \(json)") // serialized json response
                let swiftyjson = JSON(json);
                self.request.user_id = swiftyjson["id"].int
                self.request.saveUser()
                
                self.performSegue(withIdentifier: "loginSuccess", sender: sender)
            }
            else {
                // Alert to show that the login failed.
                let fail = UIAlertController(title: "Alert", message: "Login failed. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                fail.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(fail, animated: true, completion: nil)
            }
        }
//        self.request.user_id = 1
//        self.request.saveUser()
    }

}

