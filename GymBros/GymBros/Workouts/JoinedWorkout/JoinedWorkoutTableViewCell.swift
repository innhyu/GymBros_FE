//
//  JoinedWorkoutTableViewCell.swift
//  GymBros
//

import UIKit
import Alamofire
import SwiftyJSON

class JoinedWorkoutTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    var user_id: Int?
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
        
        Alamofire.request("https://cryptic-temple-10365.herokuapp.com/joined_workouts/\(user_id!)/accept", method: .patch)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                
                print("JSON: \(json)") // serialized json response
                let swiftyjson = JSON(json)
                
                self.acceptButton.isHidden = true
                self.declineButton.isHidden = true
                
            }
        }
    }
    
//    @IBAction func declineUser(){
//
//        Alamofire.request("https://cryptic-temple-10365.herokuapp.com/joined_workouts/\(user_id!)", method: .delete)
//            .validate(statusCode: 200..<300)
//            .responseJSON { response in
//                print("Request: \(String(describing: response.request))")   // original url request
//                print("Response: \(String(describing: response.response))") // http url response
//                print("Result: \(response.result)")                         // response serialization result
//                
//                if let json = response.result.value {
//
//                    print("JSON: \(json)") // serialized json response
//                    let swiftyjson = JSON(json)
//
//                    if let tableController = self.parentTableController? {
//                        if let myTableView = tableController.tableView {
//                            let indexPath = myTableView.indexPath(for: self)
//                            tableController.joinedWorkouts.remove
//                        }
//                    }
//                }
//        }
//    }
    
}
