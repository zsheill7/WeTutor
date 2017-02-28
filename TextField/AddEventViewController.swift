//
//  ViewController.swift
//  Band App Test
//
//  Created by Zoe Sheill on 6/22/16.
//  Copyright © 2016 ClassroomM. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SCLAlertView

extension NSDate
{
    func getDateString(dateString:String) -> NSDate{
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        let d = dateStringFormatter.date(from: dateString)!
        return NSDate(timeInterval:0, since:d)
        
     
    }
}

let eventPickerData = ["Marching Band Sectional", "Concert Band Sectional", "Ensemble Rehearsal", "Reminder"]
let bandTypePickerData = ["Marching Band", "Concert Band"]

class AddEventTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    @IBOutlet weak var eventDescription: UITextField!
    
 
    @IBOutlet weak var myDatePicker: UIDatePicker!
    
    @IBOutlet weak var eventType: UIPickerView!
    
    @IBOutlet weak var bandType: UIPickerView!

    var willRepeat = false
    
    var activityIndicator = UIActivityIndicatorView()
    
    //let formatter = DateFormatter()
    

    let user = FIRAuth.auth()?.currentUser
    
    
    func displayAlert(title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
    }
    
    var eventRef: FIRDatabaseReference!

    @IBOutlet weak var calendar: FSCalendar!
    // @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate let gregorian: Calendar! = Calendar(identifier:Calendar.Identifier.gregorian)
    
        
    @IBAction func addEventButton(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let pickerEvent = String(eventPickerData[eventType.selectedRow(inComponent: 0)])
        
        let bandTypeEvent = String(eventPickerData[bandType.selectedRow(inComponent: 0)])

        //let attrString = NSAttributedString(string: dateString, attributes:attributes)
        
        var eventDescriptionText = " "
        if eventDescription.text != nil {
            eventDescriptionText = eventDescription.text!
        }
        //var newEvent: eventItem = eventItem(title: pickerEvent, date: myDatePicker.date, description: eventDescriptionText, UUID: "sdfg")
        
        //eventList.append(newEvent)
        //print(eventList)
        //NSUserDefaults.standardUserDefaults().setObject(eventList, forKey: "eventList")
        let cal = NSCalendar.current
        var placeholderDate = myDatePicker.date
        
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let currentYearInt = Int((calendar?.component(NSCalendar.Unit.year, from: NSDate() as Date))!)
        let currentMonthInt = (calendar?.component(NSCalendar.Unit.month, from: NSDate() as Date))!
        var endOfSchoolYear: Int?
        
        print(currentYearInt)
        print(currentMonthInt)
        print(willRepeat)
        
        if currentMonthInt > 6 {
            endOfSchoolYear = currentYearInt + 1
        } else {
            endOfSchoolYear  = currentYearInt
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = NSDate()
        let endOfSchool = date.getDateString(dateString: "\(endOfSchoolYear!)-06-20")
    
        if willRepeat == false {
            
            let UUID = NSUUID().uuidString
            /*let event = NSObject(className: "Event")
       
            
            event["title"] = pickerEvent
            
            event["date"] = myDatePicker.date
            
            event["description"] = eventDescriptionText
            
            event["willRepeat"] = willRepeat
            
            event["UUID"] = UUID
            
            if pickerEvent == "Marching Band Sectional" {
                let userInstrument = User.currentUser()!.objectForKey("marchingInstrument")
                event.addObject(userInstrument!, forKey: "instrument")
                event.addObject("Marching Band", forKey: "ensemble")
                
            } else {
                
               
                    event.addObject(User.currentUser()!.objectForKey("concertInstrument")!, forKey: "instrument")
                event.addObject(User.currentUser()!.objectForKey("concertBandType")!, forKey: "ensemble")
                
            }*/
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            /*event.saveInBackgroundWithBlock{(success, error) -> Void in
                self.activityIndicator.stopAnimating()
                
                
                
                if error == nil {
                    
                    let marchingInstrument = self.user!["marchingInstrument"] as! String
                    let concertInstrument = self.user!["concertInstrument"] as! String
                    if event["title"] as! String == "Reminder" {
                        let installation = PFInstallation.currentInstallation()
                        PFCloud.callFunctionInBackground("startJob", withParameters: ["message" : "test2", "marchingInstrument": marchingInstrument, "concertInstrument": concertInstrument, "isMarching": "true"]) { (response: AnyObject?, error) in
                            if error == nil {
                                print("Retrieved")
                                print(installation["concertInstrument"])
                            } else {
                                print(error)
                            }
                        }
                    }
                    
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        [unowned self] in
                        //self.performSegueWithIdentifier("addEvent", sender: self)
                        let VC = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController")
                        self.presentViewController(VC!, animated: true, completion: nil)
                    }

                } else {
                    self.displayAlert("Could not add event", message: "Please try again later or contact an admin")
                }
            }*/
        } else if willRepeat == true {
            let UUID = NSUUID().uuidString
            
            /*while placeholderDate.earlierDate(endOfSchool).isEqualToDate(placeholderDate) {
            
                
                let event = NSObject(className: "Event")
                
                event["title"] = pickerEvent
                
                event["date"] = placeholderDate
                
                event["description"] = eventDescriptionText
                
                
                event["willRepeat"] = true
                
                event["UUID"] = UUID
                if bandTypeEvent == "Marching Band" {
                    
                let marchingInstrument = PFUser.currentUser()!.objectForKey("marchingInstrument")
                event.addObject(marchingInstrument!, forKey: "instrument")
                 event.addObject("Marching Band", forKey: "ensemble")
                    
                } else {
                    let concertInstrument = PFUser.currentUser()!.objectForKey("concertInstrument") as! String
                    print(concertInstrument)
                    let concertBandType = PFUser.currentUser()!.objectForKey("concertBandType") as! String
                    print("here")
        
                    event.addObject(concertInstrument, forKey: "instrument")
                    event.addObject(concertBandType, forKey: "ensemble")
               
                    
                }
                
                UIApplication.shared.endIgnoringInteractionEvents()
                
                event.saveInBackgroundWithBlock{(success, error) -> Void in
                    self.activityIndicator.stopAnimating()
                    
                    
                    
                    if error == nil {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            [unowned self] in
                            //self.performSegueWithIdentifier("addEvent", sender: self)
                            let VC = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController")
                            self.presentViewController(VC!, animated: true, completion: nil)
                        }
                        
                    } else {
                        self.displayAlert("Could not add event", message: "Please try again later or contact an admin")
                    }
                }
             //   placeholderDate = cal.dateByAddingUnit(.Day, value: 7, toDate: placeholderDate, options: [])!
                placeholderDate = cal.date(byAdding: .Day, value: 7, to: placeholderDate)!

            }
            willRepeat = false*/
            
        }

        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventRef = FIRDatabase.database().reference().child("events")
        
        
        eventDescription.delegate = self
        
        
        //formatter.dateStyle = .longStyle
       // formatter.timeStyle = .shortStyle
        eventType.dataSource = self
        eventType.delegate = self
        
        bandType.dataSource = self
        bandType.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
     self.view.endEditing(true)
     return false
     }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
   func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == eventType {
            return eventPickerData.count
        }
        return bandTypePickerData.count
  
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == eventType {
            return eventPickerData[row]
        }
        return bandTypePickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        /*        */
    }
    
    


}

