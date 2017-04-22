//
//  TutorSignUpViewController.swift
//  TextField
//
//  Created by Zoe on 12/21/16.
//  Copyright © 2017 Zoe Sheill. All rights reserved.
//

import UIKit
import Eureka
import Material
import SCLAlertView
import Firebase
import FirebaseDatabase
import CoreLocation
import NVActivityIndicatorView

private enum MenuSection {
    case all(content: AllContent)
    case menuView(content: MenuViewContent)
    case menuController(content: MenuControllerContent)
    
    fileprivate enum AllContent: Int { case standard, segmentedControl, infinite }
    fileprivate enum MenuViewContent: Int { case underline, roundRect }
    fileprivate enum MenuControllerContent: Int { case standard }

    init?(indexPath: IndexPath) {
        switch ((indexPath as NSIndexPath).section, (indexPath as NSIndexPath).row) {
        case (0, let row):
            guard let content = AllContent(rawValue: row) else { return nil }
            self = .all(content: content)
        case (1, let row):
            guard let content = MenuViewContent(rawValue: row) else { return nil }
            self = .menuView(content: content)
        case (2, let row):
            guard let content = MenuControllerContent(rawValue: row) else { return nil }
            self = .menuController(content: content)
        default: return nil
        }
    }
    
    var options: PagingMenuControllerCustomizable {
        let options: PagingMenuControllerCustomizable
        options = PagingMenuOptions1()
        return options
        
    }
}

class SettingsBasicInfoTableViewController : FormViewController {
    var ref: FIRDatabaseReference!
    
    
    func displayAlert(_ title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
        
    }
    
    let cols = 4
    let rows = 8
    var cellWidth = 2
    var cellHeight = 2
    
    struct Static {
        static let nameTag = "name"
        static let passwordTag = "password"
        static let lastNameTag = "lastName"
        static let zipcodeTag = "zipcode"
        static let emailTag = "email"
        static let schoolTag = "school"
        static let phoneTag = "phone"
        static let enabled = "enabled"
        static let check = "check"
        static let segmented = "segmented"
        static let gender = "gender"
        static let birthday = "birthday"
        static let subjects = "subjects"
        static let button = "button"
        static let stepper = "stepper"
        static let slider = "slider"
        static let textView = "textview"
    }

    func goBackToSettings() {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "settingsNC") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
       typealias Emoji = String
    var currentUser: User?
    var currentUserIsTutor: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FriendSystem.system.getCurrentUser {_ in
            self.currentUser = FriendSystem.system.currentUser
        }

        if currentUser != nil {
            self.currentUserIsTutor = currentUser?.isTutor
        }
        
        cellWidth = Int(self.view.frame.width / CGFloat(cols))
        cellHeight = Int(self.view.frame.height / CGFloat(rows))
        
        self.view?.backgroundColor = UIColor.backgroundBlue()

        form +++
            
            Section()
            
            <<< ZipCodeRow("zipcode") {
                $0.title = "Zipcode"
                $0.tag = "zipcode"
                $0.value = currentUser?.address
            }
            
            <<< TextRow("school") {
                $0.title = "School Name"
                $0.tag = "school"
               $0.value = currentUser?.school
            }
            
            <<< PhoneRow("phone") {
                $0.title = "Phone Number"
                $0.tag = "phone"
                $0.value = currentUser?.phone
            }
            
            
            +++ Section()
            
            <<< PickerInputRow<String>("Picker Input Row"){
                $0.title = "Gender"
                $0.options = ["Male", "Female", "Other"]
                
                $0.value = currentUser?.gender
            }
            
            
            <<< PushRow<Emoji>() {
                $0.title = "Grade"
                $0.options = gradeLevels
                $0.value = currentUser?.grade
                $0.selectorTitle = "Choose your grade level"
                }.onPresent { from, to in
                    to.sectionKeyForValue = { option in
                        guard let value = option as? String else { return "" }
                        return value
                    }
            }
            
            
            <<< PushRow<Emoji>() {
                $0.title = "Preferred Subject"
                $0.options = subjectNames
                $0.value = currentUser?.preferredSubjects[0]
                $0.selectorTitle = "Choose your preferred subject(s)"
                }.onPresent { from, to in
                    to.sectionKeyForValue = { option in
                        switch option {
                        case "English", "History": return "Humanities"
                        case "Math", "Chemistry", "Physics", "Biology": return "STEM"
                        case "Spanish", "French", "Chinese", "German", "Latin": return "Languages"
                        default: return ""
                        }
                    }
            }
            
            +++ Section("Biography")
            
            <<< TextRow("gpa") {
                $0.title = "GPA (4.0 scale)"
                $0.tag = "gpa"
                $0.value = String(describing: currentUser?.gpa)
                if currentUserIsTutor != nil {
                    $0.hidden = .function([""], { form -> Bool in
                        return !self.currentUserIsTutor!
                    })
                    
                } else {
                    $0.hidden = false
                }
            }
            
            <<< TextAreaRow("description") {
                $0.value = currentUser?.description
                $0.tag = "description"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 90)
                }.cellSetup({ (cell, row) in
                    cell.backgroundColor = UIColor.white
                    
                    
                    cell.textView.backgroundColor = UIColor.clear
                })
            
            +++ Section()
            <<< ButtonRow() {
                $0.title = "Save"
                }
                .onCellSelection { cell, row in
                    print("here0")
                    self.continueSelected()
                    self.goBackToSettings()
                    
            }

            /* cellWidth = Int(self.view.frame.width / CGFloat(cols))
             cellHeight = Int(self.view.frame.height / CGFloat(rows))*/
            

            //self.view.addBackground("book.png")
            
           // self.hideKeyboardWhenTappedAround()
        }
    
    func continueSelected() {
        print("here1")
        let row1: ZipCodeRow? = self.form.rowBy(tag: "zipcode")
        let zipcode = row1?.value
        
        let row2: TextRow? = self.form.rowBy(tag: "school")
        let school = row2?.value
        let row3: PhoneRow? = self.form.rowBy(tag: "phone")
        let phone = row3?.value
        let row4: PickerInlineRow<String>? = self.form.rowBy(tag: "gender")
        let gender = row4?.value
        let row5: PickerInlineRow<String>? = self.form.rowBy(tag: "grade")
        let grade = row5?.value
        let row6: MultipleSelectorRow<Emoji>? = self.form.rowBy(tag: "subject")
        let subject = row6?.value
        
        var subjectArray: [String]?
        if subject != nil {
            subjectArray = Array(subject!)
        }
        let row7: TextAreaRow? = self.form.rowBy(tag: "description")
        let description = row7?.value
        
        let row8: TextRow? = self.form.rowBy(tag: "gpa")
        let gpa = row8?.value
        
        if zipcode != nil, school != nil, phone != nil, gender != nil, grade != nil, subjectArray != nil {
            
            self.ref = FIRDatabase.database().reference()
            
            
            let userDefaults = UserDefaults.standard
            userDefaults.set(description, forKey: "description")
            let user = FIRAuth.auth()?.currentUser
            
            let userID = FIRAuth.auth()?.currentUser?.uid
            self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                print("got snapshot")
                
                let value = snapshot.value as? NSDictionary
                print("value?[name] as? String \(value?["name"] as? String)")
                print("value?[password] as? String \(value?["password"] as? String)")
                print("value?[email] as? String \(value?["email"] as? String)")
                print("value?[isTutor] as? String \(value?["isTutor"] as? Bool)")
                if let name = value?["name"] as? String,
                    let password = value?["password"] as? String,
                    let email = value?["email"] as? String,
                    let isTutor = value?["isTutor"] as? Bool{
                    
                    let x = Int(self.view.center.x)
                    let y = Int(self.view.center.y)
                    let frame = CGRect(x: x, y: y, width: self.cellWidth, height: self.cellHeight)
                    
                    let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                                        type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.lineScale.rawValue) )
                    let animationTypeLabel = UILabel(frame: frame)
                    
                    animationTypeLabel.text = "Loading..."
                    animationTypeLabel.sizeToFit()
                    animationTypeLabel.textColor = UIColor.white
                    animationTypeLabel.frame.origin.x += 5
                    animationTypeLabel.frame.origin.y += CGFloat(self.cellHeight) - animationTypeLabel.frame.size.height
                    
                    activityIndicatorView.padding = 20
                    self.view.addSubview(activityIndicatorView)
                    self.view.addSubview(animationTypeLabel)
                    activityIndicatorView.startAnimating()
                    
                    self.ref.child("users/\(userID!)/zipcode").setValue(zipcode)
                    self.ref.child("users/\(userID!)/schoolName").setValue(school)
                    self.ref.child("users/\(userID!)/phone").setValue(phone)
                    self.ref.child("users/\(userID!)/gender").setValue(gender)
                    self.ref.child("users/\(userID!)/grade").setValue(grade)
                    self.ref.child("users/\(userID!)/preferredSubject").setValue(subjectArray)
                    self.ref.child("users/\(userID!)/description").setValue(description)
                    self.ref.child("users/\(userID!)/gpa").setValue(gpa)
                    
                    FIRAnalytics.setUserPropertyString(school, forName: "school")
                    FIRAnalytics.setUserPropertyString(gender, forName: "gender")
                    FIRAnalytics.setUserPropertyString(grade, forName: "grade")
                    FIRAnalytics.setUserPropertyString(gpa, forName: "gpa")
                    
                    for subject in subjectArray! {
                        FIRAnalytics.setUserPropertyString(subject, forName: "preferred_subject")
                    }

                    let geocoder = CLGeocoder()
                    geocoder.geocodeAddressString(zipcode!) { placemarks, error in
                        if error != nil {
                            print(error?.localizedDescription ?? "")
                        } else {
                            for placemark in placemarks! {
                                let location = placemark.location
                                let latitude = location?.coordinate.latitude
                                let longitude = location?.coordinate.longitude
                                self.ref.child("users/\(userID!)/latitude").setValue(latitude)
                                self.ref.child("users/\(userID!)/longitude").setValue(longitude)
                            }
                        }
                    }
                    activityIndicatorView.stopAnimating()

                } else {
                    self.displayAlert("You are not signed in", message: "Please log in again")
                }
            }) { (error) in
                self.displayAlert("Error", message: error.localizedDescription)
            }

        } else {
            self.displayAlert("Error", message: "Please fill out every section.")
        }
        
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    

}




    

