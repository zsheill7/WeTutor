//
//  TutorSignUpViewController.swift
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
import FirebaseAnalytics
import NVActivityIndicatorView

var gradeLevels = ["Kindergarten", "1st grade", "2nd grade", "3rd grade", "4th grade", "5th grade", "6th grade", "7th grade", "8th grade", "9th grade", "10th grade", "11th grade", "12th grade", "Undergraduate", "Graduate"]
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




class TutorSignUpViewControllerOne : FormViewController, NVActivityIndicatorViewable {
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
    
   
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    typealias Emoji = String
    var currentUserIsTutor: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        FriendSystem.system.getCurrentUser {_ in 
            let currentUser = FriendSystem.system.currentUser
            if currentUser != nil {
                self.currentUserIsTutor = currentUser?.isTutor
            }
            
        }
        
        navigationAccessoryView = NavigationAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        print("self.currentUserIsTutor \(self.currentUserIsTutor)")
        self.loadForm()
       
    }
    
    func loadForm() {
        form
            
            +++ Section("Basic Info")
            
            
            <<< ZipCodeRow("zipcode") {
                $0.title = "Zipcode"
                $0.tag = "zipcode"
                $0.placeholder = "90210"
            }
            
            <<< TextRow("school") {
                $0.title = "School Name"
                $0.tag = "school"
                $0.placeholder = "Mercer Island High School"
            }
            
            <<< PhoneRow("phone") {
                $0.title = "Phone Number"
                $0.tag = "phone"
                $0.placeholder = "12062752633"
            }
            
            +++ Section()
            
            
            <<< PickerInlineRow<String>("gender") { (row : PickerInlineRow<String>) -> Void in
                row.title = "Gender"
                row.tag = "gender"
                row.options = ["Male", "Female", "Other"]
                
                row.value = row.options[0]
            }
            
            <<< PickerInlineRow<String>("grade") { (row : PickerInlineRow<String>) -> Void in
                row.title = "Grade"
                row.tag = "grade"
                row.options = gradeLevels
                
                row.value = row.options[0]
            }

            
            <<< MultipleSelectorRow<Emoji>("subject") {
                $0.title = "Preferred Subject"
                $0.tag = "subject"
                $0.options = subjectNames
                $0.value = ["Math"]
                }
                .onPresent { from, to in
                    to.view.backgroundColor = UIColor.backgroundBlue()
                    to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: from, action: #selector(self.multipleSelectorDone(_:)))
            }

            +++ Section("Biography")
            
            
            <<< TextRow("gpa") {
                $0.title = "GPA (4.0 scale)"
                $0.tag = "gpa"
                $0.placeholder = "3.6"
                if currentUserIsTutor != nil {
                    if currentUserIsTutor == true {
                        $0.hidden = false
                    } else {
                        $0.hidden = true
                    }
                    
                } else {
                    $0.hidden = false
                }
            }
            
            <<< TextAreaRow("description") {
                $0.placeholder = "Tell us a bit about yourself. This will appear on your profile."
                $0.tag = "description"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 90)
                }.cellSetup({ (cell, row) in
                    cell.backgroundColor = UIColor.clear
                   
                
                    cell.textView.backgroundColor = UIColor.clear
                })
            
            +++ Section()
            <<< ButtonRow() {
                $0.title = "Continue"
                }
                .onCellSelection { cell, row in
                    print("here0")
                    let size = CGSize(width: 30, height:30)
                    
                    self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 6)!)
                    
                    self.continueSelected()
        }
    }
    
    func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
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
                    
                    
                    
                    let size = CGSize(width: 30, height:30)
                    
                    
                    
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
                   
                        
                    print("error=nil")
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
                    self.stopAnimating()
                    
                    self.performSegue(withIdentifier: "toSecondVC", sender: self)
                    
                   
                } else {
                    self.displayAlert("You are not signed in", message: "Please log in again")
                    self.stopAnimating()
                }
                
                
                // ...
            }) { (error) in
                self.displayAlert("Error", message: error.localizedDescription)
                self.stopAnimating()
                
            }
            
            
            
            
            
        } else {
            self.displayAlert("Error", message: "Please fill out every section.")
            self.stopAnimating()
            
        }

    }
    
    
    func tableView(_ tableView: UITableView,
                            willDisplayHeaderView view: UIView,
                            forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.backgroundView?.backgroundColor = UIColor(white: 1, alpha: 0.0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //
        self.tableView?.tableFooterView = UIView()
        
    }
    
   
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 1.0)
    }
   
   
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
   



