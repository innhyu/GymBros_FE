//
//  WorkoutEditViewController.swift
//  GymBros
//

import UIKit
import Alamofire
import SwiftyJSON

class WorkoutEditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    //Mark: - Properties
  var workout: Workout?
  let locations = ["Wiegand Gymnasium", "Jared L. Cohon Center Gymnasium", "Skibo Gymnasium"]
  let locationPicker = UIPickerView()
  let durations = [30,45,60,75,90,120,150,180]
  let durationPicker = UIPickerView()
  let datePicker = UIDatePicker()
  let request = Request()
  
  @IBOutlet weak var workoutTitle: UITextField!
  @IBOutlet weak var workoutTime: UITextField!
  @IBOutlet weak var workoutDuration: UITextField!
  @IBOutlet weak var workoutLocation: UITextField!
  @IBOutlet weak var teamSize: UITextField!
  
  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
      self.navigationItem.title = "Edit Workout"
    
      self.workoutTitle.text = self.workout!.title!
      self.workoutTime.text = self.workout!.time!
      self.workoutDuration.text = String(self.workout!.duration!)
      self.workoutLocation.text = self.workout!.location!
      self.teamSize.text = String(self.workout!.teamSize!)
    
      // Loading User
      request.loadUser()
    
      // Buttons for toolbar UI
      let doneDateButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
      let doneLocationButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancelPicker));
      let doneDurationButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancelPicker));
      let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
      let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker));
    
      // Location Picker
      workoutLocation.inputView = locationPicker
      locationPicker.delegate = self
      workoutLocation.text = locations[0]
    
      let locationToolbar = UIToolbar();
      locationToolbar.sizeToFit();
      locationToolbar.setItems([spaceButton, doneLocationButton, cancelButton], animated: false)
      workoutLocation.inputAccessoryView = locationToolbar
    
      // Duration Picker
      workoutDuration.inputView = durationPicker
      durationPicker.delegate = self
    
      let durationToolbar = UIToolbar();
      durationToolbar.sizeToFit();
      durationToolbar.setItems([spaceButton, doneDurationButton, cancelButton], animated: false)
      workoutDuration.inputAccessoryView = durationToolbar
    
      // Date Picker
      datePicker.datePickerMode = UIDatePickerMode.dateAndTime
      workoutTime.inputView = datePicker
    
      let dateToolbar = UIToolbar();
      dateToolbar.sizeToFit()
      dateToolbar.setItems([spaceButton,doneDateButton,cancelButton], animated: false)
      workoutTime.inputAccessoryView = dateToolbar
    }
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
    }
  
    @objc func doneDatePicker() {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd HH:mm"
      workoutTime.text = formatter.string(from: datePicker.date)
      self.view.endEditing(true)
    }
  
    @objc func cancelPicker() {
      self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      if pickerView == locationPicker {
        return self.locations.count
      }
        // case of pickerView == durationPicker
      else {
        return self.durations.count
      }
    }
  
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      if pickerView == locationPicker {
        return self.locations[row]
      }
        // case of pickerView == durationPicker
      else {
        return String(self.durations[row])
      }
    }
  
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      if pickerView == locationPicker {
        workoutLocation.text = self.locations[row]
      }
        // case of pickerView == durationPicker
      else {
        workoutDuration.text = String(self.durations[row])
      }
    }
  
    @IBAction func editWorkout(_ sender: Any?) {
      // Fetching fields from the inputs
      let title: String? = self.workoutTitle.text;
      let time: String? = self.workoutTime.text;
      let duration: Int? = Int(self.workoutDuration.text!);
      let location: String? = self.workoutLocation.text?.uppercased();
      // Type isn't used yet
      // let type = self.workoutType.text;
      let teamSize: Int? = Int(self.teamSize.text!);
      
      // Constructing parameter needed for Alamofire Request
      let parameters: Parameters = [
        // TODO: Do something with user_id
        "user_id": self.request.user_id!,
        "title": title ?? "",
        "time": time ?? "", // "Format is in -> 2007-12-04 00:00:00 -0000"
        "duration": duration ?? "",
        // Do something with location to make a dropdown
        "location": location ?? "",
        "team_size": teamSize ?? ""
      ]
      
      // Making Alamofire request
      Alamofire.request("https://cryptic-temple-10365.herokuapp.com/workouts/\(self.workout!.id!)", method: .patch, parameters: parameters)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
          print("Request: \(String(describing: response.request))")   // original url request
          print("Response: \(String(describing: response.response))") // http url response
          print("Result: \(response.result)")                         // response serialization result
          
          if let json = response.result.value {
            
            print("JSON: \(json)") // serialized json response
            let swiftyjson = JSON(json);
            
            let success = UIAlertController(title: "Success", message: "Workout Edited. Please wait for a few seconds before the updates are reflected.", preferredStyle: UIAlertControllerStyle.alert)
            success.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
              self.navigationController?.popViewController(animated: true)
            }))
            self.present(success, animated: true, completion: nil)
          }
          else {
            // Alert to show that the workout create failed to the user.
            let fail = UIAlertController(title: "Failed", message: "Failed to update the workout. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
            fail.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(fail, animated: true, completion: nil)
          }
      }
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
