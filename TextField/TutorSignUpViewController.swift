//
//  TutorSignUpViewController.swift
//  TextField
//
//  Created by Zoe on 12/21/16.
//  Copyright © 2016 CosmicMind. All rights reserved.
//

import UIKit
//import Eureka
import Material
//import ChameleonFramework
import SwiftForms
import SCLAlertView
import Firebase
import FirebaseDatabase
import CoreLocation

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
        switch self {
        case .all(let content):
            switch content {
            case .standard:
                options = PagingMenuOptions1()
            case .segmentedControl:
                options = PagingMenuOptions2()
            case .infinite:
                options = PagingMenuOptions3()
            }
        case .menuView(let content):
            switch content {
            case .underline:
                options = PagingMenuOptions4()
            case .roundRect:
                options = PagingMenuOptions5()
            }
        case .menuController(let content):
            switch content {
            case .standard:
                options = PagingMenuOptions6()
            }
        }
        return options
    }
}
/*enum RepeatInterval : String, CustomStringConvertible {
    case Never = "Never"
    case Every_Day = "Every Day"
    case Every_Week = "Every Week"
    case Every_2_Weeks = "Every 2 Weeks"
    case Every_Month = "Every Month"
    case Every_Year = "Every Year"
    
    var description : String { return rawValue }
    
    static let allValues = [Never, Every_Day, Every_Week, Every_2_Weeks, Every_Month, Every_Year]
}

enum EventAlert : String, CustomStringConvertible {
    case Never = "None"
    case At_time_of_event = "At time of event"
    case Five_Minutes = "5 minutes before"
    case FifTeen_Minutes = "15 minutes before"
    case Half_Hour = "30 minutes before"
    case One_Hour = "1 hour before"
    case Two_Hour = "2 hours before"
    case One_Day = "1 day before"
    case Two_Days = "2 days before"
    
    var description : String { return rawValue }
    
    static let allValues = [Never, At_time_of_event, Five_Minutes, FifTeen_Minutes, Half_Hour, One_Hour, Two_Hour, One_Day, Two_Days]
}

enum EventState {
    case busy
    case free
    
    static let allValues = [busy, free]
}*/

class TutorSignUpViewController: FormViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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

class TutorSignUpViewControllerOne : FormViewController {
    var ref: FIRDatabaseReference!
    
    func displayAlert(title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
        
    }
    
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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initializeForm()
        
        self.view.addBackground(imageName: "mixed2")
        
    }
    
    // MARK: Actions
    
    func submit(_: UIBarButtonItem!) {
        
        let message = self.form.formValues().description
        
        let alertController = UIAlertController(title: "Form output", message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "OK", style: .cancel) { (action) in
        }
        
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Private interface
    
    
    fileprivate func loadForm() {
        
        let form = FormDescriptor(title: "Example Form")
        
        var row = FormRowDescriptor(tag: Static.emailTag, type: .email, title: "Email")
        
        /*let section1 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        
        row.configuration.cell.appearance = ["textField.placeholder" : "john@gmail.com" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section1.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.passwordTag, type: .password, title: "Password")
        row.configuration.cell.appearance = ["textField.placeholder" : "Enter password" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section1.rows.append(row)
        
         
        row = FormRowDescriptor(tag: Static.nameTag, type: .name, title: "First Name")
        row.configuration.cell.appearance = ["textField.placeholder" : "e.g. Miguel Ángel" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section2.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.lastNameTag, type: .name, title: "Last Name")
        row.configuration.cell.appearance = ["textField.placeholder" : "e.g. Ortuño" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section2.rows.append(row)*/
        
        let section1 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)

        
        row = FormRowDescriptor(tag: Static.zipcodeTag, type: .text, title: "Zip Code")
        row.configuration.cell.appearance = ["textField.placeholder" : "e.g. 98040" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section1.rows.append(row)
        
        let section2 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        row = FormRowDescriptor(tag: Static.schoolTag, type: .url, title: "School Name")
        row.configuration.cell.appearance = ["textField.placeholder" : "e.g. Mercer Island High School" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section2.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.phoneTag, type: .phone, title: "Phone")
        row.configuration.cell.appearance = ["textField.placeholder" : "e.g. 13069242633" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section2.rows.append(row)
        
        let section3 = FormSectionDescriptor(headerTitle: "An example header title", footerTitle: nil)
        
        row = FormRowDescriptor(tag: Static.gender, type: .picker, title: "Gender")
        row.configuration.cell.showsInputToolbar = true
        row.configuration.selection.options = (["F", "M", "U"] as [String]) as [AnyObject]
        row.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? String else { return "" }
            switch option {
            case "F":
                return "Female"
            case "M":
                return "Male"
            case "U":
                return "Other/I'd rather not say"
            default:
                return ""
            }
        }
        
        row.value = "M" as AnyObject
        
        section3.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.birthday, type: .date, title: "Birthday")
        row.configuration.cell.showsInputToolbar = true
        section3.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.subjects, type: .multipleSelector, title: "Preferred Subject")
        row.configuration.selection.options = ([0, 1, 2] as [Int]) as [AnyObject]
        row.configuration.selection.allowsMultipleSelection = true
        row.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? Int else { return "" }
            switch option {
            case 0:
                return "Math"
            case 1:
                return "Reading or writing"
            case 2:
                return "Science"
                
                
            default:
                return ""
            }
        }
        
        section3.rows.append(row)

        
       
        
        let section4 = FormSectionDescriptor(headerTitle: "Description", footerTitle: nil)
        row = FormRowDescriptor(tag: Static.textView, type: .multilineText, title: "About Me")
        section4.rows.append(row)
        
        let section5 = FormSectionDescriptor(headerTitle: " ", footerTitle: nil)
        
        //row.configuration.cell.appearance = ["textField.placeholder" : "This will be a part of your profile. Tell us about yourself. What are your extracurriculars?  Do you have experience with working with children?" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        row = FormRowDescriptor(tag: Static.button, type: .button, title: "Continue")
        row.configuration.button.didSelectClosure = { _ in
            self.view.endEditing(true)
           // self.form.validateForm()
           if let zipcode = self.form.sections[0].rows[0].value,
            let schoolName = self.form.sections[1].rows[0].value,
            let phone    = self.form.sections[1].rows[1].value,
            let gender    = self.form.sections[2].rows[0].value,
            let birthday    = self.form.sections[2].rows[1].value,
            let preferredSubject = self.form.sections[2].rows[2].value,
            let description = self.form.sections[3].rows[0].value {
            
                self.ref = FIRDatabase.database().reference()
            
            
                let userDefaults = UserDefaults.standard
            
            
                
            
            
                if let email = userDefaults.value(forKey: "email"),
                    let password = userDefaults.value(forKey: "password"),
                    let name = userDefaults.value(forKey: "name"),
                    let user = FIRAuth.auth()?.currentUser {
                    
                    self.ref.child("users").child(user.uid).setValue(["zipcode": zipcode,
                                                                      "schoolName": schoolName,
                                                                      "phone": phone,
                                                                      "gender": gender,
                                                                      "birthday": birthday,
                                                                      "preferredSubject": preferredSubject,
                                                                      "description": description,
                                                                      "email": email,
                                                                      "password": password,
                                                                      "name": name], withCompletionBlock: { (error, ref) in
                       if error == nil {
                            var geocoder = CLGeocoder()
                            geocoder.geocodeAddressString(zipcode as! String) { placemarks, error in
                                if error != nil {
                                    print("error")
                                } else {
                                    for placemark in placemarks! {
                                        let location = placemark.location
                                        self.ref.child("users/\(user.uid)/location").setValue(location)
                                    }
                                }
                            }
                        
                            self.performSegue(withIdentifier: "toSecondVC", sender: self)
                       } else {
                            self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                       }
                    })
                }
            
            
            
           } else {
                self.displayAlert(title: "Error", message: "Please fill out every section.")
            }
            
            
        }
        section5.rows.append(row)
        
        form.sections = [section1, section2, section3, section4, section5]
        
        self.form = form
    }
}



