//
//  JoinedWorkoutTableViewCell.swift
//  GymBros
//

import UIKit
import Alamofire
import SwiftyJSON

class JoinedWorkoutTableViewCell: UITableViewCell {

  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var identity: UILabel!
  @IBOutlet weak var acceptButton: UIButton!
  @IBOutlet weak var declineButton: UIButton!
    
  var user_id: Int?
  var id: Int?
  var parentTableController: JoinedWorkoutTableViewController?
    
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func acceptUser(){
        
        Alamofire.request("https://cryptic-temple-10365.herokuapp.com/joined_workouts/\(id!)/accept", method: .patch)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                
              print("JSON: \(json)") // serialized json response
              let swiftyjson = JSON(json)
              self.setMember();
            
            }
        }
    }
    
    @IBAction func declineUser(){

        Alamofire.request("https://cryptic-temple-10365.herokuapp.com/joined_workouts/\(id!)", method: .delete)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
              
                if let json = response.result.value {

                    print("JSON: \(json)") // serialized json response
                    let swiftyjson = JSON(json)

                    // Reloading data from the actual view request.. quickest way for now.
                    if let tableController = self.parentTableController {
                      if let workoutShowVC = tableController.parent as? WorkoutShowViewController {
                        workoutShowVC.alamoRequest();
                      }
                    }
                }
        }
    }
  
  // Change user status to owner
  func setOwner() {
    self.identity.text = "Owner"
    self.identity.backgroundColor = UIColor(red: 45/255, green: 94/255, blue: 255/255, alpha: 0.5)
    self.hideButtons();
  }
  
  // Change user status to member
  func setMember() {
    self.identity.text = "Member"
    self.identity.backgroundColor = UIColor(red: 128/255, green: 232/255, blue: 38/255, alpha: 0.5)
    self.hideButtons();
  }
  
  // Change user status to pending
  func setPending() {
    self.identity.text = "Pending"
    self.identity.backgroundColor = UIColor(red: 212/255, green: 232/255, blue: 226/255, alpha: 1.0)
  }
  
  // Hide all buttons on the cell
  func hideButtons() {
    self.acceptButton.isHidden = true
    self.declineButton.isHidden = true
  }
    
}
