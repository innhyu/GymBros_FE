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
  
    @IBOutlet weak var check_in_input: UITextField!
    @IBOutlet weak var check_in_button: UIButton!
    @IBOutlet weak var helper_text: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.check_in_input.text = String(self.check_in_code!)
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
