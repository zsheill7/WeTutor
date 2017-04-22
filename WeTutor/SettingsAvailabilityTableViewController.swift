
//  SettingsAvailabilityTableViewController.swift
//
//  Created by Zoe on 3/6/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//


import UIKit
import Eureka
import CoreLocation
import FirebaseDatabase
import Firebase



import SCLAlertView
import Firebase

class SettingsAvailabilityTableViewController : FormViewController {
    
    let firstLanguages = ["English", "Spanish", "French", "Chinese", "Other"]
    let secondLanguages = ["None", "English", "Spanish", "French", "Chinese", "Other"]

  
    var ref: FIRDatabaseReference!

    
    func displayAlert(title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
        
    }
    
    //MARK: - viewDidLoad
    var currentUser: User?
    var currentUserIsTutor: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("currentUser?.phone as AnyObject?")
        print(currentUser?.phone as AnyObject?)
        //initializeForm()
        
        
        FriendSystem.system.getCurrentUser {_ in
            
        }
        
         currentUser = FriendSystem.system.currentUser
        if currentUser != nil {
            self.currentUserIsTutor = currentUser?.isTutor
        }
        let availabilityInfo: String = ""
        var languages: [String] = [String]()
        
        
        ref = FIRDatabase.database().reference()
        form
            
             +++ Section("Available Days")
            
            
            
            <<< WeekDayRow("Available Days"){
                $0.value = [.monday, .wednesday, .friday]
                
            }
            
            +++ Section("More Info on Availability (optional)")

            <<< TextAreaRow("Availability Notes") {
                $0.placeholder = currentUser?.availabilityInfo
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 70)
                
                
                $0.value = currentUser?.availabilityInfo
            }
            
            +++ Section("Languages")
            
                    <<< PickerInlineRow<String>("First Language") { (row : PickerInlineRow<String>) -> Void in
                        row.title = "First Language"
                        row.options = firstLanguages
                        
                        //row.value = row.options[0]
                        row.value = currentUser?.languages[0]
                    }
                    <<< PickerInlineRow<String>("Second Language") { (row : PickerInlineRow<String>) -> Void in
                        row.title = row.tag
                        row.options = secondLanguages
                        
                        //row.value = row.options[0]
                        if currentUser?.languages != nil && (currentUser?.languages.count)! > 1 {
                            row.value = currentUser?.languages[1]
                        }
                    }
                    <<< PickerInlineRow<String>("Third Language") { (row : PickerInlineRow<String>) -> Void in
                        row.title = row.tag
                        row.options = secondLanguages
                        
                        //row.value = row.options[0]
                        if currentUser?.languages != nil && (currentUser?.languages.count)! > 1 {
                            row.value = currentUser?.languages[2]
                        }
                }
        
            +++ Section("Prices")

            <<< DecimalRow("Price") {
                $0.useFormatterDuringInput = true
                $0.title = "Price"
                $0.value = currentUser?.hourlyPrice
                let formatter = CurrencyFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                $0.formatter = formatter
                if currentUserIsTutor != nil {
                    $0.hidden = .function([""], { form -> Bool in
                        return !self.currentUserIsTutor!
                    })
                    
                } else {
                    $0.hidden = false
                }
            }
            

            
            +++ Section()
            <<< ButtonRow() {
                $0.title = "Save"
                }
                .onCellSelection { cell, row in
                    
                    self.continueSelected()
                    self.goBackToSettings()

        }
    }
    
    func continueSelected() {
        let userDefaults = UserDefaults.standard
        
        
        var languages: [String] = [String]()
        
        let row1: WeekDayRow? = self.form.rowBy(tag: "Available Days")
        let daysValue = row1?.value
        
        //
        var weekDayString = ""
        var weekDayArray:[Bool] = []
        let weekDayCell = WeekDayCell()
        if daysValue != nil {
            weekDayString = weekDayCell.getStringFromArray(daysValue!)
            weekDayArray = weekDayCell.getBoolArrayFromArray(daysValue!)
            print("daysValue: " + weekDayString)
        } else {
            print( "if daysValue == nil" )
        }
        
        
        let row2: TextRow? = self.form.rowBy(tag: "Availability Notes")
        let availabilityInfo = row2?.value
        row2?.cell.contentView.tintColor = UIColor(white: 1, alpha: 0.7)
        
        var firstLanguage = ""
        if let row3 = self.form.rowBy(tag: "First Language") as? TextRow? {
            firstLanguage = (row3?.value)!
        } else {
            firstLanguage = "English"
        }
        
        
        print(firstLanguage)
        let row4: TextRow? = self.form.rowBy(tag: "Second Language")
        let secondLanguage = row4?.value
        
        let row5: TextRow? = self.form.rowBy(tag: "Third Language")
        let thirdLanguage = row5?.value
        
        if firstLanguage != "None" {
            languages.append(firstLanguage)
            FIRAnalytics.setUserPropertyString(firstLanguage, forName: "first_language")
        }
        if secondLanguage != "None" && secondLanguage != nil{
            languages.append(secondLanguage!)
            FIRAnalytics.setUserPropertyString(secondLanguage, forName: "second_language")
        }
        if thirdLanguage != "None" && thirdLanguage != nil{
            languages.append(thirdLanguage!)
            FIRAnalytics.setUserPropertyString(thirdLanguage, forName: "third_language")
        }
        
        print(languages)
        
        let row6: DecimalRow? = self.form.rowBy(tag: "Price")
        let hourlyPrice = row6?.value
        if hourlyPrice != nil {
            FIRAnalytics.setUserPropertyString(String(describing: hourlyPrice), forName: "third_language")
        }
        
        
        for i in 0...6 {
            FIRAnalytics.setUserPropertyString("\(weekDayArray[i])", forName: "\(weekdays[i])_available")
        }
        FIRAnalytics.setUserPropertyString(availabilityInfo, forName: "availability_info")
        
        
        
        userDefaults.setValue(weekDayString, forKey: "availableDays")
        userDefaults.setValue(languages, forKey: "languages")
        userDefaults.setValue(availabilityInfo, forKey: "availabilityInfo")
        userDefaults.synchronize()
        
        if let user = FIRAuth.auth()?.currentUser {
            self.ref.child("users/\(user.uid)/availableDays").setValue(weekDayString)
            self.ref.child("users/\(user.uid)/availableDaysArray").setValue(weekDayArray)
            self.ref.child("users/\(user.uid)/languages").setValue(languages)
            self.ref.child("users/\(user.uid)/availabilityInfo").setValue(availabilityInfo)
            self.ref.child("users/\(user.uid)/completedTutorial").setValue(false)
            self.ref.child("users/\(user.uid)/hourlyPrice").setValue(hourlyPrice)
            
        } else {
            // No user is signed in.
            // ...
        }
    }
   
    func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func goBackToSettings() {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "settingsNC") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
}


