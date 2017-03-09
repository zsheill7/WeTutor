//
//  SecondViewController.swift
//  Band App Test
//
//  Created by Zoe Sheill on 6/23/16.
//  Copyright © 2016 ClassroomM. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SCLAlertView
import EventKit
import EventKitUI
import DropDown

struct properties {
    static let pickerEvents = [
        ["title" : "Log In as a Member", "color" : UIColor.buttonBlue()],
        ["title" : "About This App", "color": UIColor.buttonBlue()],
        ["title" : "Contact Us", "color" : UIColor.buttonBlue()],
        
        ]
    static let memberPickerEvents = [
        ["title" : "Settings", "color" : UIColor.buttonBlue()],
        ["title" : "About This App", "color": UIColor.buttonBlue()],
        ["title" : "Contact Us", "color" : UIColor.buttonBlue()],
        
        ]
}

enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}


var eventList = [eventItem]()




class UpcomingEventTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate, EKEventEditViewDelegate {
    /*@available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }*/
    
    
    
    
    var eventStore: EKEventStore!
    
    @IBOutlet weak var nagivationItem: UINavigationItem!
    //@IBOutlet weak var table: UITableView!
  

    @IBOutlet weak var tableView: UITableView!
    
    
  // let dateFormatter = DateFormatter()
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    
    @IBAction func addEvent(_ sender: Any) {
        let addController = EKEventEditViewController()
        
        // Set addController's event store to the current event store
        addController.eventStore = eventStore!
        addController.editViewDelegate = self
        self.present(addController, animated: true, completion: nil)
        
    }
    
    
    
    
    var instruments:[String] = []
    var ensembles:[String] = []
    var events = [eventItem]()
    
    var user = FIRAuth.auth()?.currentUser

    var refresher: UIRefreshControl!
    var detailVC: DetailViewController? = nil

    let picker = UIImageView(image: UIImage(named: "Custom Picker View 2"))
    
    var pickerFrame: CGRect?
    
    var willRepeat = false
    
    var activityIndicator = UIActivityIndicatorView()
    
    
    class func instantiateFromStoryboard() -> UpcomingEventTableViewController {
        let storyboard = UIStoryboard(name: "MenuViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "UpcomingEventTableViewController") as! UpcomingEventTableViewController
        /*let storyboard = UIStoryboard(name: "MenuViewController", bundle: nil)
         return storyboard.instantiateViewController(withIdentifier: "UsersViewController") as! TutorsTableViewController*/
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2015/01/01")!
        
        
    
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2016/10/31")!
    }

    
    
    
    func displayAlert(title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
    }
    
    
    /*override func viewDidLoad() {
        super.viewDidLoad()
         //dateFormatter.dateFormat = "YYYY/MM/DD"
        //animateTable()
      //  let installation = PFInstallation.currentInstallation()
        
        /*if User.currentUser()?.username != nil {
            if installation["marchingInstrument"] == nil {
                print("here3")
                /* installation.addObject(PFUser.currentUser()!["marchingInstrument"], forKey: "channels")*/
                installation.setObject(User.currentUser()!["concertInstrument"], forKey: "concertInstrument")
                installation.setObject(User.currentUser()!["marchingInstrument"], forKey: "marchingInstrument")
                //installation["concertInstrument"] = [PFUser.currentUser()!["concertInstrument"]]
                //print(installation.objectId)
                installation.saveInBackground()
            }
        }*/
        
        
        print("here2")
        /*if PFUser.currentUser()?.username != nil {
            print("here3")
           /* installation.addObject(PFUser.currentUser()!["marchingInstrument"], forKey: "channels")*/
            installation.setObject(PFUser.currentUser()!["concertInstrument"], forKey: "concertInstrument")
            installation.setObject(PFUser.currentUser()!["marchingInstrument"], forKey: "marchingInstrument")
            //installation["concertInstrument"] = [PFUser.currentUser()!["concertInstrument"]]
            //print(installation.objectId)
            installation.saveInBackground()
            print("here")
            //print(installation["concertInstrument"])
            PFCloud.callFunctionInBackground("iospush", withParameters: ["message" : "test2", "marchingInstrument": "Alto Saxophone", "concertInstrument": "Flute", "isMarching": "true"]) { (response: AnyObject?, error) in
                if error == nil {
                    print("Retrieved")
                    print(installation["concertInstrument"])
                } else {
                    print(error)
                }
            }
        }*/

        
        
       /* let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
        if notificationType == UIUserNotificationType.none {
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }else{
            // Push notifications are enabled in setting by user.
            
        }*/
        
        
        
        self.dismissKeyboard()
       
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action:  #selector(UpcomingEventTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
       
        table.addSubview(refresher)
        refresher.endRefreshing()
       // self.hideKeyboardWhenTappedAround()
        navigationItem.hidesBackButton = true
        
        //var isAdmin = user!["isAdmin"] as! Bool
        
        //TrakTableData()

        
        pickerFrame = CGRect(x: ((self.view.frame.width - picker.frame.size.width) - 10), y: 70, width: 200, height: 160)
        
        //createPicker()
        
        self.view.endEditing(true)
        
        
    }*/
    
        // EKEventStore instance associated with the current Calendar application
    
    
    // Default calendar associated with the above event store
    var defaultCalendar: EKCalendar!
    
    // Array of all events happening within the next 24 hours
    var eventsList: [EKEvent] = []
    
    // Used to add events to Calendar
   // @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    //MARK: -
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize the event store
        eventStore = EKEventStore()
        // Initialize the events list
        // The Add button is initially disabled
      //  self.addButton.isEnabled = false
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Check whether we are authorized to access Calendar
        self.checkEventStoreAccessForCalendar()
    }
    
    
    // This method is called when the user selects an event in the table view. It configures the destination
    // event view controller with this event.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEventViewController" {
            // Configure the destination event view controller
            let eventViewController = segue.destination as! EKEventViewController
            // Fetch the index path associated with the selected event
            let indexPath = self.tableView.indexPathForSelectedRow
            // Set the view controller to display the selected event
            eventViewController.event = self.eventsList[(indexPath?.row)!]
            
            // Allow event editing
            eventViewController.allowsEditing = true
        }
    }
    
    
    //MARK: -
    //MARK: Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventsList.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        
        // Get the event at the row selected and display its title
        let title = self.eventsList[indexPath.row].title
        let dateString = String(describing: self.eventsList[indexPath.row].startDate)
       // cell.detailTextLabel?.text = String(describing: self.eventsList[indexPath.row].startDate)
        cell.textLabel?.attributedText = makeAttributedString(title: title, subtitle: dateString)

        return cell
    }
    
    func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline), NSForegroundColorAttributeName: UIColor.purple]
        let subtitleAttributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .subheadline)]
        
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
        
        titleString.append(subtitleString)
        
        return titleString
    }
    
    
    //MARK: -
    //MARK: Access Calendar
    
    // Check the authorization status of our application for Calendar
    private func checkEventStoreAccessForCalendar() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch status {
        // Update our UI if the user has granted access to their Calendar
        case .authorized: self.accessGrantedForCalendar()
        // Prompt the user for access to Calendar if there is no definitive answer
        case .notDetermined: self.requestCalendarAccess()
        // Display a message if the user has denied or restricted access to Calendar
        case .denied, .restricted:
            let alertController = UIAlertController(title: "Privacy Warning", message: "Permission was not granted for Calendar", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: {action in})
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    // Prompt the user for access to their Calendar
    private func requestCalendarAccess() {
        eventStore.requestAccess(to: .event) {[weak self] granted, error in
            if granted {
                // Let's ensure that our code will be executed from the main queue
                DispatchQueue.main.async {
                    // The user has granted access to their Calendar; let's populate our UI with all events occuring in the next 24 hours.
                    self?.accessGrantedForCalendar()
                }
            }
        }
    }
    
    
    // This method is called when the user has granted permission to Calendar
    private func accessGrantedForCalendar() {
        // Let's get the default calendar associated with our event store
        self.defaultCalendar = eventStore.defaultCalendarForNewEvents
        // Enable the Add button
       // self.addButton.isEnabled = true
        // Fetch all events happening in the next 24 hours and put them into eventsList
        self.eventsList = self.fetchEvents()
        // Update the UI with the above events
        self.tableView.reloadData()
    }
    
    
    //MARK: -
    //MARK: Fetch events
    
    // Fetch all events happening in the next 24 hours
    private func fetchEvents() -> [EKEvent] {
        let startDate = Date()
        
        //Create the end date components
        var tomorrowDateComponents = DateComponents()
        tomorrowDateComponents.day = 1
        
        let endDate = Calendar.current.date(byAdding: tomorrowDateComponents,
                                            to: startDate)!
        // We will only search the default calendar for our events
        let calendarArray: [EKCalendar] = [self.defaultCalendar]
        
        // Create the predicate
        let predicate = eventStore.predicateForEvents(withStart: startDate,
                                                           end: endDate,
                                                           calendars: calendarArray)
        
        // Fetch all events that match the predicate
        let events = eventStore.events(matching: predicate)
        
        return events
    }
    
    
    //MARK: -
    //MARK: Add a new event
    
    // Display an event edit view controller when the user taps the "+" button.
    // A new event is added to Calendar when the user taps the "Done" button in the above view controller.
    func addEvent() {
        // Create an instance of EKEventEditViewController
        let addController = EKEventEditViewController()
        
        // Set addController's event store to the current event store
        addController.eventStore = eventStore!
        addController.editViewDelegate = self
        self.present(addController, animated: true, completion: nil)
    }
    
    
    //MARK: -
    //MARK: EKEventEditViewDelegate
    
    // Overriding EKEventEditViewDelegate method to update event store according to user actions.
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        // Dismiss the modal view controller
        self.dismiss(animated: true) {[weak self] in
            if action != .canceled {
                DispatchQueue.main.async {
                    // Re-fetch all events happening in the next 24 hours
                    self?.eventsList = self!.fetchEvents()
                    // Update the UI with the above events
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    
    // Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
    func eventEditViewControllerDefaultCalendar(forNewEvents controller: EKEventEditViewController) -> EKCalendar {
        return self.defaultCalendar
    }
    
}

   /* override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closePicker()
    }
    
     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            
            
            let detailNC = segue.destination as! UINavigationController
            let detailVC = detailNC.topViewController as! DetailViewController
            if let indexPath = self.table.indexPathForSelectedRow {
                detailVC.eventTitleText = events[indexPath.row].title
                detailVC.dateText = events[indexPath.row].getDateString()
                detailVC.eventDescriptionText = events[indexPath.row].description
                detailVC.instrumentText = events[indexPath.row].instrument
            }
        }
        
        
    }
    
    func animateTable() {
        table.reloadData()
        
        let cells = table.visibleCells
        
        let tableViewHeight = table.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(a: tableViewHeight, b: tableViewHeight, c: tableViewHeight, d: tableViewHeight, tx: 0, ty: tableViewHeight)
        }
        
        var delayCounter = 0
        
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter), usingSpringWithDamping: 0.85, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.init()
                }, completion: nil)
            delayCounter += 1
        }
        
    }*/




