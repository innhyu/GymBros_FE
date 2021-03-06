//
//  RegisterViewController.swift
//  GymBros
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  let genders = ["Male", "Female", "Other"]
  
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
    let genderPicker = UIPickerView()
    gender.inputView = genderPicker
    genderPicker.delegate = self
    self.navigationItem.title = "Register"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = true
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.genders.count
  }
  
  func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return self.genders[row]
  }
  
  func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    gender.text = self.genders[row]
    self.view.endEditing(true)
  }
  
  @IBAction func register(_ sender: Any) {
    
    // Fetching parameters needed for the registration
    let email: String? = self.userEmail.text
    let password: String? = self.password.text
    let passwordConfirmation: String? = self.passwordConfirmation.text
    let firstName: String? = self.firstName.text
    let lastName: String? = self.lastName.text
    let gender: String? = self.gender.text
    let age: Int? = Int(self.age.text ?? "")

    // Constructing the parameters needed for the AlamoFire call
    let parameters: Parameters = [
      "email": email ?? "",
      "password": password ?? "",
      "password_confirmation": passwordConfirmation ?? "",
      "role": "Real",
      "first_name": firstName ?? "",
      "last_name": lastName ?? "",
      "gender": gender ?? "",
      "age": age ?? "",
    ]

    // Alamofire call to make the actual user
    Alamofire.request("https://cryptic-temple-10365.herokuapp.com/users.json", method: .post, parameters: parameters)
      .validate(statusCode: 200..<300)
      .responseJSON { response in
        print("Request: \(String(describing: response.request))")   // original url request
        print("Response: \(String(describing: response.response))") // http url response
        print("Result: \(response.result)")                         // response serialization result

        if let json = response.result.value {

          print("JSON: \(json)") // serialized json response
          // Do something with this data!
          let swiftyjson = JSON(json);
          
          // Showing the alert that tells user registration is complete;
          // SIDE: Popping back to the login screen
          let success = UIAlertController(title: "Alert", message: "User registered. Please login with the credentials.", preferredStyle: UIAlertControllerStyle.alert)
          success.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.navigationController?.popViewController(animated: true)
          }))
          self.present(success, animated: true, completion: nil)
        }
        else {
          // Alert to show that the registration failed.
          let fail = UIAlertController(title: "Alert", message: "Registration failed. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
          fail.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
          self.present(fail, animated: true, completion: nil)
        }
      }
    }
  
  // Mark: - Touch Formatting
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
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
