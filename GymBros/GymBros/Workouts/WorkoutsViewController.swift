//
//  WorkoutsViewController.swift
//  GymBros
//
//  Created by 이인혁 on 03/12/2018.
//  Copyright © 2018 Carnegie Mellon University IS Dept. All rights reserved.
//

import UIKit

class WorkoutsViewController: UIViewController {
  // Mark: - Properties
  let request = Request()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    request.loadUser()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  

  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if segue.identifier == "showMyProfile" {
      let destination = segue.destination as! ProfileViewController;
      destination.user_id = request.user_id!
    }
  }

}
