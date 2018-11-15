//
//  ShowViewController.swift
//  GymBros
//
//  Created by Dylan Schwartz on 11/9/18.
//  Copyright © 2018 Carnegie Mellon University IS Dept. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ShowViewController: UIViewController {
  
  @IBOutlet var name: UILabel!
  @IBOutlet var time: UILabel!
  @IBOutlet var location: UILabel!
  @IBOutlet var type: UILabel!
  @IBOutlet var size: UILabel!
  var index: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let row = String(self.index!)
    Alamofire.request("https://cryptic-temple-10365.herokuapp.com/workouts/"+row).responseJSON { response in
      print("Request: \(String(describing: response.request))")   // original url request
      print("Response: \(String(describing: response.response))") // http url response
      print("Result: \(response.result)")                         // response serialization result
      
      if let json = response.result.value {
        
        print("JSON: \(json)") // serialized json response
        let swiftyjson = JSON(json)
        print(swiftyjson[self.index!])
        self.name.text = swiftyjson["workout"]["title"].string
        self.time.text = swiftyjson["workout"]["title"].string
        self.location.text = swiftyjson["workout"]["location"].string
        //        self.type.text = swiftyjson["workout"]["location"].string // There is no workout type yet;
        self.size.text = swiftyjson["workout"]["\"team_size\""].string
        
      }
    }
    
  }
  
  func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    if (segue.identifier == "toShowPage") {
      let index = sender as! IndexPath
      self.index = index.row
    }
  }
  
}
