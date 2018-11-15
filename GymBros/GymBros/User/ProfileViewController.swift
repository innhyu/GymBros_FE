//
//  ProfileViewController.swift
//  GymBros
//
//  Created by 이인혁 on 15/11/2018.
//  Copyright © 2018 Carnegie Mellon University IS Dept. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController {
    let request = Request()
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var gender: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.request.loadUser()
        if let user_id = self.request.user_id {
            Alamofire.request("https://cryptic-temple-10365.herokuapp.com/users/\(user_id)", method: .get)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    print("Request: \(String(describing: response.request))")   // original url request
                    print("Response: \(String(describing: response.response))") // http url response
                    print("Result: \(response.result)")                         // response serialization result
                    
                    if let json = response.result.value {
                        
                        print("JSON: \(json)") // serialized json response
                        let swiftyjson = JSON(json);
                        self.firstName.text = swiftyjson["first_name"].string
                        self.lastName.text = swiftyjson["last_name"].string
                        self.age.text = String(swiftyjson["age"].int ?? 9999)
                        self.gender.text = swiftyjson["gender"].string
                    }
            }
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
