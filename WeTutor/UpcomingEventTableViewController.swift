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
import Hero
import BubbleTransition
import PullToRefresh

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



extension Date {
    func adding(months: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.month = months
        
        return calendar.date(byAdding: components, to: self)
        
    }
}

//var eventList = [eventItem]()




class UpcomingEventTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate, EKEventEditViewDelegate {
  
    
    
    
    var eventStore: EKEventStore!
    
   // @IBOutlet weak var nagivationItem: UINavigationItem!
    //@IBOutlet weak var table: UITableView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addEventButton: UIButton!
    
  // let dateFormatter = DateFormatter()
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    
    @IBAction func addEvent(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "MenuViewController", bundle: nil)
        
       // let controller = storyboard.instantiateViewController(withIdentifier: "addEventVC") as! AddEventViewController
        //let controller = storyboard.instantiateViewController(withIdentifier: "AddEventChannelListViewController") as! AddEventChannelListViewController
        //let controller = storyboard.instantiateViewController(withIdentifier: "addEventNC") as! UINavigationController
        
        //Hero.shared.setDefaultAnimationForNextTransition(.push(direction: .right))
        //hero_replaceViewController(with: controller)
        /*let addController = EKEventEditViewController()
        
        // Set addController's event store to the current event store
        addController.eventStore = eventStore!
        addController.editViewDelegate = self*/
        //self.present(controller, animated: true, completion: nil)
        self.performSegue(withIdentifier: "toAddEventNC", sender: self)
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
    var calendars: [EKCalendar] = []
    
   // var events = [eventItem]()
    var willRepeat = false
    
    @IBOutlet weak var calendarView: FSCalendar!
    
    var currentUserIsTutor = false
    
    var iterationStatus = ""
    
    var tutorName: String = ""
    var tuteeName: String = ""
    var tutorOrTutee = "tutorName"
    
    let now = Date()
   // var currentUserIsTutor = false
    
    class func instantiateFromStoryboard() -> UpcomingEventTableViewController {
        let storyboard = UIStoryboard(name: "MenuViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "UpcomingEventTableViewController") as! UpcomingEventTableViewController
        /*let storyboard = UIStoryboard(name: "MenuViewController", bundle: nil)
         return storyboard.instantiateViewController(withIdentifier: "UsersViewController") as! TutorsTableViewController*/
    }
    var datesWithEvent:[Date] = []
    
    func calendar(_ calendar: FSCalendar, hasEventFor date: Date) -> Bool {
        print("has event for")
        for event in self.events {
            datesWithEvent.append(event.startDate as Date)
            let order = Calendar.current.compare(event.startDate as Date, to: date as Date, toGranularity: .day)
            if order == ComparisonResult.orderedSame {
               // let unitFlags: NSCalendar.Unit = [.day, .month, .year]
                let unitFlags:Set<Calendar.Component> = [
                    .hour, .day, .month,
                    .year,.minute,.hour,/*.second,
                    .calendar*/]
                let calendar2: Calendar = Calendar.current
                let components: DateComponents = calendar2.dateComponents(unitFlags, from: Date()) //calendar2.components(unitFlags, fromDate: event.startDate)
                datesWithEvent.append(calendar2.date(from: components)!/*calendar.date(from: components)*//*calendar2.dateComponents(components)!*/)
            }
        }
        return datesWithEvent.contains(date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        /*let key = self.dateFormatter1.string(from: date)
        if let color = self.borderDefaultColors[key] {
            return color
        }
        return appearance.borderDefaultColor*/
        return UIColor.white
        for event in self.events {
            let order = Calendar.current.compare(event.startDate as Date, to: date, toGranularity: .day)
            print("for event in self.events")
            if order == .orderedSame {
                print("orderedsame")
                // numberOfEvents += 1
                //return event.numberOfEvent
                return UIColor.white
            }
            
        }
        return appearance.borderDefaultColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
       
        return 20.0
    }
    
   /* func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        /*for event in self.events {
            let order = Calendar.current.compare(event.startDate!, to: date, toGranularity: .day)
           
            return event.numb
            
        }*/
        return self.events.count
        //return 0
    }*/
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
      // var numberOfEvents = 0
        
        print("number of events for date")
        for event in self.events {
            let order = Calendar.current.compare(event.startDate as Date, to: date, toGranularity: .day)
            print("for event in self.events")
            if order == .orderedSame {
                print("orderedsame")
               // numberOfEvents += 1
                //return event.numberOfEvent
                return 1
            }
            
        }
        return 0//numberOfEvents
        
       /* for data in eventsArray{
            let order = NSCalendar.currentCalendar().compareDate(data.eventDate!, toDate: date, toUnitGranularity: .Day)
            if order == NSComparisonResult.OrderedSame{
                return data.numberOfEvent!
            }
        }
        return 0*/
        /*let day: Int! = self.gregorian.component(.day, from: date)
        return day % 5 == 0 ? day/5 : 0;*/
    }
    
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        //return self.formatter.date(from: "2015/01/01")!
        let sixMonthsAgo = now.adding(months: -6)
        return sixMonthsAgo!
        //return self.formatter.date(from: "2015/01/01")!
        
        
    
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
       // return self.formatter.date(from: "2016/10/31")!
       let sixMonthsFuture = now.adding(months: 6)
        return sixMonthsFuture!
    }

    
    
    
    func displayAlert(title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
    }
    
    
   
    
        // EKEventStore instance associated with the current Calendar application
    
    
    // Default calendar associated with the above event store
    var defaultCalendar: EKCalendar!
    
    // Array of all events happening within the next 24 hours
    //var eventsList: [EKEvent] = []
    
    // Used to add events to Calendar
   // @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    //MARK: -
    //MARK: View lifecycle
    
  //  @IBOutlet weak var calendarWidthConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("FIRAuth.auth.currentUser.uid \(FIRAuth.auth()?.currentUser?.uid)")
        // Initialize the event store
       // eventStore = EKEventStore()
        self.transitioningDelegate = self
       eventStore = EKEventStore()
        self.setupCalendarAppearance()
        
        
        self.initializeDateFormatter()
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.isUserInteractionEnabled = false
        
        self.view.addBackground()
    //    calendarWidthConstraint.constant = self.view.frame.size.width
        self.tableView.backgroundColor = UIColor.clear
        //self.calendarView.width = self.view.width + 20
        FriendSystem.system.getCurrentUser { (user) in
            //self.usernameLabel.text = user.email
        }
        //FriendSystem.system.friendList.removeAll()
        FriendSystem.system.addFriendObserver(friendListNumber: 3) {
           // print("inside FriendSystem.system.addFriendObserver")
             print("jaFriendSystem.system.friendListThree  \(FriendSystem.system.friendListThree.count)")
            self.loadAllEvents(completed: {
                for event in self.events {
                    print("event.uid \(event.uid)\n event.title \(event.title)")
                }
                self.observeChannels()
                self.tableView.reloadData()
                self.calendarView.reloadData()
                
            })

           /* self.loadAllEvents{ () -> () in
                self.newQuestion()
            }
            self.observeChannels()
            self.tableView.reloadData()*/
            print("1FriendSystem.system.friendListThree \(FriendSystem.system.friendListThree.count)")
            
            
        }
        
        let refresher = PullToRefresh()
        tableView.addPullToRefresh(refresher) {
            let when = DispatchTime.now() + 1.2
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.tableView.endRefreshing(at: .top)
                //self.tableView.removePullToRefresh(self.tableView.topPullToRefresh!)
                
            }
        }
       
        self.view.bringSubview(toFront: addEventButton)
        
       // let calendars = eventStore.calendars(for: .event)
        
        
        
        // Initialize the events list
        // The Add button is initially disabled
        //  self.addButton.isEnabled = false
    }
    
    var events: [Event] = [Event]()
   /* func displayAllCalendars() {
        //self.events.removeAll()
        print("in display all calendars")
        /*var titles : [String] = []
        var startDates : [NSDate] = []
        var endDates : [NSDate] = []*/
        
        for calendar in calendars {
            print(" in for calendar")
            print(calendars.count)
            //  if calendar.title == "Work" {
            print("for calendar in calendars {")
            let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
            let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
            
            let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])
            
            var events = eventStore.events(matching: predicate)
            
            for event in events {
                self.events.append(event)
                print("events.count" + String(events.count))
                 print("self.events.count" + String(self.events.count))
                
                /*titles.append(event.title)
                startDates.append(event.startDate as NSDate)
                endDates.append(event.endDate as NSDate)*/
            //}
        }
        }
        tableView.reloadData()
    }*/
    
    /*func addEventsToCalendar() {
        for event in self.events {
            
        }
    }*/
    var ref: FIRDatabaseReference!
    
    
    fileprivate func observeChannels() {
        // We can use the observe method to listen for new
        // channels being written to the Firebase DB
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        let userChannelRef = userRef.child(userID!).child("channels")
        
        print("inside observeChannels)")
    
        print("for friend in FriendSystem.system.friendList")
        
        //let userID = FIRAuth.auth()?.currentUser?.uid
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
            
            /*self.calendars.removeAll()
            for channel in userObject.channels {
                
                let calendarId = channel.calendarId
                if let newCalendar = self.eventStore.calendar(withIdentifier: calendarId)
                {
                    self.calendars.append(newCalendar)
                    
                } else {
                    //self.createCalendar(channel.id)
                }
                //self.channels.append(channel)
                
                
            }*/
        })
         self.tableView.reloadData()
        
    }
    
    
    
    /*func loadCalendar() {
        let userID = FIRAuth.auth()?.currentUser?.uid
        let userChannelRef = userRef.child(userID!).child("channels")
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let userObject = User(snapshot: snapshot )
            
            self.currentUser = userObject
            
            let value = snapshot.value as? NSDictionary
            
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
    }*/
    
    
    // TODO: handle returning the default EKCalendar
    /*func loadCalendar(_ calendarId: String) -> EKCalendar {
        if let calendar = eventStore.calendar(withIdentifier: calendarId) {
            return calendar
        }
        return EKCalendar()
    }
    */
    /*func loadAllCalendars() {
        print("loadAllCalendars()")
        let friendList = FriendSystem.system.friendList
        print("friendList.count \(friendList.count)")
        print(friendList.count)
        //let destUserID = destUser.uid
        let channelRef = FIRDatabase.database().reference().child("channels")
        
        channelRef.observeSingleEvent(of: .value, with: { (snapshot) in
            print("channelRef.observeSingleEvent(of: .value, with: { (snapshot) in")
            if snapshot.exists() {
                print(" if snapshot.exists() {")
                if let allChannels = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    print("typeofall")
                    print(type(of: allChannels))
                    print("if let allChannels = ((snapshot.value as AnyObject).allKeys)! as? [String] {")
                    self.iterationStatus = "inProcess"
                    for channel in allChannels {
                        
                        if let channelDict = channel.value as? Dictionary<String, AnyObject> {
                            
                            print(" if let channelDict = channel.value as? Dictionary<String, AnyObject> {")
                            //print(" if let channel = snapshot.value as? [String: String] {")
                            //This iterates through the channel list and checks if either the tutorName or the tutorName is equal to the current user
                            for destUser in friendList {
                                let destUserID = destUser.uid
                                if self.currentUserIsTutor == false {
                                    print("if self.currentUserIsTutor == false {")
                                    if let tuteeName = channelDict["tuteeName"] as? String,
                                        let  tutorName = channelDict["tutorName"] as? String{
                                        print(" let  tutorName = channelDict[tutorName] as? String{")
                                        if tuteeName == FIRAuth.auth()?.currentUser?.uid {
                                            print("if channel[self.tutorOrTutee] == FIRAuth.auth()?.currentUser?.uid {")
                                            
                                            if tutorName == destUserID {
                                                self.iterationStatus = "done"
                                                print("perform segue channel")
                                                print(channel)
                                               // let newChannel = Channel(id: channel.key, name: "Chat", tutorName: tutorName, tuteeName: tuteeName)
                                                if let calendarId = channelDict["calendarId"] as? String {
                                                    print(" if let calendarId = channelDict[calendarId] as? String {")
                                                        if let loadedCalendar = self.eventStore.calendar(withIdentifier: calendarId) {
                                                           
                                                        
                                                            print("if let loadedCalendar = self.loadCalendar(calendarId) as? EKCalendar { calid\(calendarId)")
                                                            self.calendars.append(loadedCalendar)
                                                        }
                                                    
                                                } else {
                                                    // TODO: Handle nil case or default EKCalendar
                                                }
                                               
                                                
                                            }
                                        }
                                    }
                                    
                                } else if self.currentUserIsTutor == true {
                                    print("if self.currentUserIsTutor == true {")
                                    if let tuteeName = channelDict["tuteeName"] as? String,
                                        let  tutorName = channelDict["tutorName"] as? String{
                                         print(" let  tutorName = channelDict[tutorName] as? String{")
                                        if tutorName == FIRAuth.auth()?.currentUser?.uid {
                                            print("if channel[self.tutorOrTutee] == FIRAuth.auth()?.currentUser?.uid {")
                                            if tuteeName == destUserID {
                                                self.iterationStatus = "done"
                                                print("perform segue channel")
                                                print(channel)
                                                let newChannel = Channel(id: channel.key, name: "Chat", tutorName: tutorName, tuteeName: tuteeName)
                                                if let calendarId = channelDict["calendarId"] as? String {
                                                    if let loadedCalendar = self.eventStore.calendar(withIdentifier: calendarId) {
                                                        
                                                        
                                                        print("if let loadedCalendar = self.loadCalendar(calendarId) as? EKCalendar { calid\(calendarId)")
                                                        self.calendars.append(loadedCalendar)
                                                    }
                                                }
                                              
                                            }
                                        } //if channelDict["tutorName"]
                                    }
                                }
                            } //for destUser in friendList
                            
                        }
                        //self.displayAllCalendars()
                        self.tableView.reloadData()
                    } //for channel in allChannels {
                    
                }
                
                
                
            } //if snapshot.exists() {
            self.displayAllCalendars()
            /*let uuid = UUID().uuidString
            if self.iterationStatus == "inProcess" {
                if self.tutorOrTutee == "tuteeName" {
                    let channel = Channel(id: uuid, name: "Chat", tutorName: (FIRAuth.auth()?.currentUser?.uid)!, tuteeName: destUserID)
                    print("if tutorOrTutee == tuteeName {")
                    print("iterationStatus")
                    print(self.iterationStatus)
                    
                    self.createChannel(otherUser: destUserID)
                    print("if self.iterationStatus == inProcess1 {")
                    print("perform segue channel3")
                    print(channel)
                    
                    self.performSegue(withIdentifier: "toChatVC", sender: channel)
                    
                    
                } else if self.tutorOrTutee == "tutorName" {
                    let channel = Channel(id: uuid, name: "Chat", tutorName: destUserID, tuteeName: (FIRAuth.auth()?.currentUser?.uid)!)
                    print("if tutorOrTutee == tutorName {")
                    
                    print("if self.iterationStatus == inProcess2 {")
                    self.createChannel(otherUser: destUserID)
                    print("perform segue channel4")
                    print(channel)
                    self.performSegue(withIdentifier: "toChatVC", sender: channel)
                    
                }
            }*/
            
        })
        
        
    }*/
    
    
 
    func loadAllEvents(completed: @escaping (() -> ())) {
        print("loadAllCalendars()")
        let friendList = FriendSystem.system.friendListThree
        print("friendList.count \(friendList.count)")
        print(friendList.count)
        //let destUserID = destUser.uid
        self.events.removeAll()
        self.events = [Event]()
        let channelRef = FIRDatabase.database().reference().child("channels")
        
        channelRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            print("channelRef.observeSingleEvent(of: .value, with: { (snapshot) in")
            if snapshot.exists() {
                print(" if snapshot.exists() {")
                if let allChannels = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    print("typeofall")
                    print(type(of: allChannels))
                    print("if let allChannels = ((snapshot.value as AnyObject).allKeys)! as? [String] {")
                    self.iterationStatus = "inProcess"
                   /* for channel in allChannels {
                        
                        if let channelDict = channel.value as? Dictionary<String, AnyObject> {
                            print("1channelDict \(channelDict)")
                            print(" if let channelDict = channel.value as? Dictionary<String, AnyObject> {")
                            //print(" if let channel = snapshot.value as? [String: String] {")
                            //This iterates through the channel list and checks if either the tutorName or the tutorName is equal to the current user*/
                            for friend in friendList {
                                print("friendList \(friend.uid)")
                            }
                            for destUser in friendList {
                                let destUserID = destUser.uid
                                // else if self.currentUserIsTutor == true {
                                var channelCount = 0
                                for channel in allChannels {
                                    channelCount += 1
                                    if let channelDict = channel.value as? Dictionary<String, AnyObject> {
                                        print("1channelDict \(channelDict)")
                                        print(" if let channelDict = channel.value as? Dictionary<String, AnyObject> {")
                                        //print(" if let channel = snapshot.value as? [String: String] {")
                                        //This iterates through the channel list and checks if either the tutorName or the tutorName is equal to the current user
                                        var friendCount = 0
                                        for friend in friendList {
                                            
                                            print("friendList \(friend.uid)")
                                        }
                                        for destUser in friendList {
                                            friendCount += 1
                                            let destUserID = destUser.uid
                                            let currentUserIsTutorNameDict = [
                                                true: ["tutorName": destUserID,
                                                                       "tuteeName": FIRAuth.auth()?.currentUser?.uid],
                                                false: ["tutorName": FIRAuth.auth()?.currentUser?.uid,
                                                                       "tuteeName": destUserID]
                                            ]
                                            
                                            
                                    print("if self.currentUserIsTutor == true {")
                                    if let tuteeName = channelDict["tuteeName"] as? String,
                                        let  tutorName = channelDict["tutorName"] as? String{
                                        print("2 let  tutorName = channelDict[tutorName] as? String{")
                                        print("(currentUserIsTutorNameDict[self.currentUserIsTutor]?[tutorName])! \((currentUserIsTutorNameDict[self.currentUserIsTutor]?["tutorName"])!) \(FIRAuth.auth()?.currentUser?.uid)")
                                        if tutorName == (currentUserIsTutorNameDict[self.currentUserIsTutor]?["tutorName"])! {
                                          
                                            if tuteeName == (currentUserIsTutorNameDict[self.currentUserIsTutor]?["tuteeName"])! {
                                                self.iterationStatus = "done"
                                                
                                                 print("2if channel[self.tutorOrTutee] == FIRAuth.auth()?.currentUser?.uid { tutor\(tutorName) tutee \(tuteeName) channel \(channel.key)")
                                                print("perform segue channel upcoming event")
                                                print(channel)
                                            
                                                if let eventsDict = channelDict["events"] as? [String: [String: AnyObject]] {
                                                     print("2nd \(eventsDict)")
                                                    
                                                    for (key, event) in eventsDict {
                                                        print("2print event in eventsDict \(event)" )
                                                        let startDateDouble = event["startDate"] as? Double ?? Date().timeIntervalSince1970
                                                        let endDateDouble = event["endDate"] as? Double ?? Date().timeIntervalSince1970
                                                        let endDate = Date(timeIntervalSince1970: endDateDouble)
                                                        let startDate = Date(timeIntervalSince1970: startDateDouble)
                                                        let eventTitle = event["title"] as? String ?? "New Event"
                                                        let description = event["description"] as? String ?? "I look forward to seeing you!"
                                                        let repeatInterval = event["repeatInterval"] as? String ?? "Never"
                                                        let eventAlert = event["eventAlert"] as? String ?? "Never"
                                                        let eventLocation = event["location"] as? String ?? "Mercer Island Library"//CLLocation ?? CLLocation(latitude: 47.566951, longitude: -122.221192)
                                                        let newEvent = Event(title: eventTitle, startDate: startDate as NSDate, endDate: endDate as NSDate, description: description, location: eventLocation, repeatInterval: repeatInterval, uid: key, objectID: UUID().uuidString, eventAlert: eventAlert)
                                                        print("2newEvent \(newEvent.uid) channelCount \(channelCount) friendCount \(friendCount)")
                                                        var eventListDoesContain = false
                                                        for eventListEvent in self.events {
                                                            if eventListEvent.uid == key {
                                                                eventListDoesContain = true
                                                            }
                                                        }
                                                        if eventListDoesContain == false {
                                                            self.events.append(newEvent)
                                                        }
                                                       // print("self.events inside \(self.events.count)  \(self.events)")
                                                    }
                                                    
                                                } else {
                                                    // TODO: Handle nil case or default EKCalendar
                                                }
                                                
                                            }
                                        } //if channelDict["tutorName"]
                                    }
                                        
                                }
                            } //for destUser in friendList
                            
                        }
                        //self.displayAllCalendars()
                        self.tableView.reloadData()
                    } //for channel in allChannels {
                    
                }
                
                
                
            } //if snapshot.exists() {
           // self.displayAllCalendars()
            /*let uuid = UUID().uuidString
             if self.iterationStatus == "inProcess" {
             if self.tutorOrTutee == "tuteeName" {
             let channel = Channel(id: uuid, name: "Chat", tutorName: (FIRAuth.auth()?.currentUser?.uid)!, tuteeName: destUserID)
             print("if tutorOrTutee == tuteeName {")
             print("iterationStatus")
             print(self.iterationStatus)
             
             self.createChannel(otherUser: destUserID)
             print("if self.iterationStatus == inProcess1 {")
             print("perform segue channel3")
             print(channel)
             
             self.performSegue(withIdentifier: "toChatVC", sender: channel)
             
             
             } else if self.tutorOrTutee == "tutorName" {
             let channel = Channel(id: uuid, name: "Chat", tutorName: destUserID, tuteeName: (FIRAuth.auth()?.currentUser?.uid)!)
             print("if tutorOrTutee == tutorName {")
             
             print("if self.iterationStatus == inProcess2 {")
             self.createChannel(otherUser: destUserID)
             print("perform segue channel4")
             print(channel)
             self.performSegue(withIdentifier: "toChatVC", sender: channel)
             
             }
             }*/
            print("self.events.count \(self.events.count)")
            
         //   print("self.events \(self.events)" )
            print("right before completed")
            completed()
            
        })
        
        
        
    }
    
    /*loadAllEvents { () -> () in
        loadDataFromDatabase()
    }*/
    /*func createCalendar(_ channelId: String) {
     
        let userID = FIRAuth.auth()?.currentUser?.uid
        let userChannelRef = userRef.child(userID!).child("channels")
        
        let channelRef = FIRDatabase.database().reference().child("channels")
        
        let eventStore = EKEventStore()
        
        // Use Event Store to create a new calendar instance
        // Configure its title
        var newCalendar = EKCalendar(for: .event, eventStore: self.eventStore)
        
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
        
    }*/
 

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Check whether we are authorized to access Calendar
       // self.checkEventStoreAccessForCalendar()
        
    }
    
    func setupCalendarAppearance() {
        self.calendarView.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        //self.calendarView.select(self.formatter.date(from: "2015/10/10")!)
        //        self.calendar.scope = .week
        self.calendarView.scopeGesture.isEnabled = true
        self.calendarView.appearance.headerTitleColor = UIColor.white
        //self.calendarView.appearance.titleDefaultColor = UIColor.white
        self.calendarView.appearance.weekdayTextColor = UIColor.white
        //self.calendarView.appearance.cell
        //self.calendarView.appearance.
        self.calendarView.appearance.eventColor = UIColor.white
        self.calendarView.appearance.cellShape = .circle
        self.calendarView.appearance.borderRadius = 10
       // self.calendarView.appearance.
        
        self.calendarView.appearance.selectionColor = UIColor.white
        self.calendarView.appearance.titleSelectionColor = UIColor.red
        self.calendarView.appearance.todayColor = UIColor.red
        self.calendarView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        //self.calendarView.opacity = 0.3
        //self.calendarView.backgroundColor = UIColor(patternImage: UIImage(named:"calendar header bg")!)
      //  self.calendarView.appearance.
        //self.calendarView.appearance.headerTitleFont = [SGHelper themeFontNavBar];
        //self.calendarView.appearance.titleFont = [SGHelper themeFontWithSize:15];
        //self.calendarView.appearance.weekdayFont = [SGHelper themeFontWithSize:15]
    }
    
    /*func setupHeaderView() {
        self.headerView.avatarButton setHidden:YES];
        [self.headerView.subtitleLabel setHidden:YES];
        self.headerView.subtitleLabel.text = [SGHelper localizedFormatDate:[NSDate date]];
        [self.headerView setImage:[UIImage imageAtResourcePath:@"calendar header bg"] style:HeaderMaskStyleDark];
    }*/
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        NSLog("change page to \(self.formatter.string(from: calendar.currentPage))")
    }
    
    // This method is called when the user selects an event in the table view. It configures the destination
    // event view controller with this event.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        /*if segue.identifier == "showEventViewController" {
            // Configure the destination event view controller
            let eventViewController = segue.destination as! EKEventViewController
            // Fetch the index path associated with the selected event
            let indexPath = self.tableView.indexPathForSelectedRow
            // Set the view controller to display the selected event
            eventViewController.event = self.events[(indexPath?.row)!]
            
            // Allow event editing
            eventViewController.allowsEditing = true
        }*/
       
        
        
    }
    /*func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }*/
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    //MARK: -
    //MARK: Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    

    
    let dateFormatter = DateFormatter()
    
    func initializeDateFormatter() {
        dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss +zzzz"
        dateFormatter.locale = Locale.init(identifier: "en_US")
     //   let dateObj = dateFormatter.dateFromString(glGetString)
        
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
    }
 //   print("Dateobj: \(dateFormatter.stringFromDate(dateObj!))")
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let calendar = Calendar.current
        let eventAtRow = self.events[indexPath.row]
        tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCell")
        var cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventCell
        //cell?.contentView.backgroundColor = UIColor.blue
        cell?.backgroundColor = UIColor.clear
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        // Get the event at the row selected and display its title
        
        if cell != nil {
            print( "cell != nil")
        }
        
        let title = eventAtRow.title
        let startDateString = String(describing: eventAtRow.startDate)
        let endDateString = String(describing: eventAtRow.endDate)
        let location = String(describing: eventAtRow.location)
        let calendarMonth = calendar.component(.month, from: eventAtRow.startDate as Date)
        let calendarDay = calendar.component(.day, from: eventAtRow.startDate as Date)
        
        let formattedStartDateString = dateFormatter.string(from: eventAtRow.startDate as Date)
        let formattedEndDateString = dateFormatter.string(from: eventAtRow.endDate as Date)
        cell?.eventTitle.text = title
        cell?.eventDate.text = formattedStartDateString + " - " + formattedEndDateString
        cell?.eventDescription.text = location
        cell?.calendarMonthLabel.text = months[calendarMonth]
        cell?.calendarDateLabel.text = String(calendarDay)
        

        return cell!
    }
    
    /*fileprivate let ITEMS_KEY = "todoItems"
    func addItem(_ item: TodoItem) {
        // persist a representation of this todo item in UserDefaults
        var todoDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        todoDictionary[item.UUID] = ["deadline": item.deadline, "title": item.title, "UUID": item.UUID] // store NSData representation of todo item in dictionary with UUID as key
        UserDefaults.standard.set(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = "Todo Item \"\(item.title)\" Is Overdue" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = item.deadline as Date // todo item due date (when notification will be fired) notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["title": item.title, "UUID": item.UUID] // assign a unique identifier to the notification so that we can retrieve it later
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }*/
    
    func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline), NSForegroundColorAttributeName: UIColor.purple]
        let subtitleAttributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .subheadline)]
        
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
        
        titleString.append(subtitleString)
        
        return titleString
    }
    
    
    
   
   /* func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrinkPresentationViewController(presentedViewController:presented, presenting: presenting)
    }*/
    // MARK: UIViewControllerTransitioningDelegate
    
    public override func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = BubbleTransition()
        transition.transitionMode = .present
        transition.startingPoint = addEventButton.center
        transition.bubbleColor = UIColor.blue//addEventButton.backgroundColor!
        return transition
    }
    
    public override func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = BubbleTransition()
        transition.transitionMode = .dismiss
        transition.startingPoint = addEventButton.center
        transition.bubbleColor = addEventButton.backgroundColor!
        return transition
    }
    
   
    //MARK: -
    //MARK: Access Calendar
    
    // Check the authorization status of our application for Calendar
    /*private func checkEventStoreAccessForCalendar() {
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
        self.defaultCalendar = EKCalendar(for: .event, eventStore: self.eventStore)
        // Enable the Add button
       // self.addButton.isEnabled = true
        // Fetch all events happening in the next 24 hours and put them into eventsList
        self.events = self.fetchEvents()
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
    }*/
    
    
    //MARK: -
    //MARK: Add a new event
    
    // Display an event edit view controller when the user taps the "+" button.
    // A new event is added to Calendar when the user taps the "Done" button in the above view controller.
    /*func addEvent() {
        // Create an instance of EKEventEditViewController
        let addController = EKEventEditViewController()
        
        // Set addController's event store to the current event store
        addController.eventStore = eventStore!
        addController.editViewDelegate = self
        
        //Add a new calendar event
        FIRAnalytics.logEvent(withName: "added_calendar_event", parameters: [
            "current_user": currentUserUID! as NSObject,
            "current_user_is_tutor": currentUserIsTutor as NSObject
            ])
        self.present(addController, animated: true, completion: nil)
        tableView.reloadData()
    }*/
    
    
    //MARK: -
    //MARK: EKEventEditViewDelegate
    
    // Overriding EKEventEditViewDelegate method to update event store according to user actions.
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        // Dismiss the modal view controller
        
        //See if the user finished adding the calendar event
        FIRAnalytics.logEvent(withName: "finished_added_calendar_event", parameters: [
            "current_user": currentUserUID! as NSObject,
            "current_user_is_tutor": currentUserIsTutor as NSObject
        ])
        
        self.dismiss(animated: true) {[weak self] in
            if action != .canceled {
                DispatchQueue.main.async {
                    // Re-fetch all events happening in the next 24 hours
                    //self?.eventsList = self!.fetchEvents()
                    // Update the UI with the above events
                    self?.tableView.reloadData()
                }
            }
        }
        self.tableView.reloadData()
    }
    
    //var default​Calendar​For​New​Events:​ EKCalendar
    
    // Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
    /*func eventEditViewControllerDefaultCalendar(forNewEvents controller: EKEventEditViewController) -> EKCalendar {
        return eventStore.calendar(withIdentifier: "")!
    }*/
    
}




