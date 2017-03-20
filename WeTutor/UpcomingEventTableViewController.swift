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

    var refresher: UIRefreshControl!
    var detailVC: DetailViewController? = nil
    let picker = UIImageView(image: UIImage(named: "Custom Picker View 2"))
    var pickerFrame: CGRect?
    var activityIndicator = UIActivityIndicatorView()
    
    
    let userRef = FIRDatabase.database().reference().child("users")
    var currentUserUID = FIRAuth.auth()?.currentUser?.uid
    var currentUser: User?
    var calendars = [EKCalendar()]
    
    var events = [eventItem]()
    var willRepeat = false
    
    var currentUserIsTutor = false
    
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
        
        var titles : [String] = []
        var startDates : [NSDate] = []
        var endDates : [NSDate] = []
        
        //let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        
        for calendar in calendars {
            if calendar.title == "Work" {
                
                let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
                let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
                
                let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])
                
                var events = eventStore.events(matching: predicate)
                
                for event in events {
                    titles.append(event.title)
                    startDates.append(event.startDate as NSDate)
                    endDates.append(event.endDate as NSDate)
                }
            }
        }
        // Initialize the events list
        // The Add button is initially disabled
      //  self.addButton.isEnabled = false
    }
    
    
    fileprivate func observeChannels() {
        // We can use the observe method to listen for new
        // channels being written to the Firebase DB
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        let userChannelRef = userRef.child(userID!).child("channels")
        
        print("inside observeChannels)")
        for friend in FriendSystem.system.friendList {
            print("for friend in FriendSystem.system.friendList")
            var ref: FIRDatabaseReference!
            let userID = FIRAuth.auth()?.currentUser?.uid
            ref = FIRDatabase.database().reference()
            ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let userObject = User(snapshot: snapshot )
                
                self.currentUser = userObject
                
                let value = snapshot.value as? NSDictionary
                let isTutor = userObject.isTutor
                if isTutor != nil {
                    if isTutor == true {
                        self.currentUserIsTutor = true
                        //self.tutorOrTutee = "tuteeName"
                    } else {
                        self.currentUserIsTutor = false
                       // self.tutorOrTutee = "tutorName"
                    }
                }
                else {
                    // no highscore exists
                }
                let email = userObject.email
                //print(email)
                //print("userObject.channels")
                //print( userObject.channels)
                
                
                for channel in userObject.channels {
                    
                    let calendarId = channel.calendarId
                    if let newCalendar = self.eventStore.calendar(withIdentifier: calendarId)
                    {
                        self.calendars.append(newCalendar)
                        
                    } else {
                        self.createCalendar(channel.id)
                    }
                    //self.channels.append(channel)
                    self.tableView.reloadData()
                    
                }
            })
        }
    }
    
    func loadCalendar() {
        
    }
    
    func createCalendar(_ channelId: String) {
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        let userChannelRef = userRef.child(userID!).child("channels")
        
        let channelRef = FIRDatabase.database().reference()
        
        let eventStore = EKEventStore()
        
        // Use Event Store to create a new calendar instance
        // Configure its title
        var newCalendar = EKCalendar(for: .event, eventStore: eventStore)
        
       // newCalendar.calendarIdentifier = identifier
        
        
        // Probably want to prevent someone from saving a calendar
        // if they don't type in a name...
        newCalendar.title = "Events"
        
        
        // Access list of available sources from the Event Store
        let sourcesInEventStore = eventStore.sources
        
        // Filter the available sources and select the "Local" source to assign to the new calendar's
        // source property
        newCalendar.source = sourcesInEventStore.filter{
            (source: EKSource) -> Bool in
            source.sourceType.rawValue == EKSourceType.local.rawValue
            }.first!
        
        channelRef.child("calendarId").setValue(newCalendar.calendarIdentifier)
        userChannelRef.child("calendarId").setValue(newCalendar.calendarIdentifier)
        
        self.calendars.append(newCalendar)
        
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




