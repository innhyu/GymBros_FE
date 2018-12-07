//
//  ProfileViewController.swift
//  GymBros
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: UITableViewController {
  // Mark: - Properties
  var user_id: Int?
  let request = Request()
  
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var age: UILabel!
  @IBOutlet weak var gender: UILabel!
  @IBOutlet weak var logoutButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    self.request.loadUser()
    tableView.allowsSelection = false;
    
    Alamofire.request("https://cryptic-temple-10365.herokuapp.com/users/\(user_id!)", method: .get)
      .validate(statusCode: 200..<300)
      .responseJSON { response in
          print("Request: \(String(describing: response.request))")   // original url request
          print("Response: \(String(describing: response.response))") // http url response
          print("Result: \(response.result)")                         // response serialization result
            
          if let json = response.result.value {
            
            print("JSON: \(json)") // serialized json response
            let swiftyjson = JSON(json);
            
            // Set labels correctly
            self.setLabels(swiftyjson: swiftyjson);
          
            // Logout functionality for own profile
            if self.request.user_id! != self.user_id! {
              self.logoutButton.isHidden = true
            }
            
          }
      }
  }
  
  // Function to set the labels
  func setLabels(swiftyjson: JSON){
    self.name.text = "\(swiftyjson["first_name"].string!) \(swiftyjson["last_name"].string!)"
    self.age.text = String(swiftyjson["age"].int!)
    self.gender.text = swiftyjson["gender"].string!
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
