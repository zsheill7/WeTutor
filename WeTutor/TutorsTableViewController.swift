//
//  TutorsTableViewController.swift
//  TutorMe
//
//  Created by Zoe on 12/22/16.
//  Copyright © 2017 Zoe Sheill. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation
import SCLAlertView
import DropDown
import TwicketSegmentedControl
import EventKit
import FirebaseAnalytics
import Instructions

extension Array {
    func doesContain<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}


class TutorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    
    @IBOutlet weak var contactButton: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


struct CoachMarkInfo {
    var title: String
    var content: String
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}

class TutorsTableViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, TwicketSegmentedControlDelegate, UITableViewDelegate, UITableViewDataSource, CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    

    
   
    
   

    var dbRef: FIRDatabaseReference!
    var tutors = [User]()
    var userRef: FIRDatabaseReference!
    var senderDisplayName: String?
    var newChannel: Channel?
    var destinationUser: User!
    var currentUser: User?
    
    var finalUserList = [User]()
    var friendUserUIDList = [String]()
    
    @IBOutlet weak var tableView: UITableView!
   // @IBOutlet weak var dropdownView: UIView!
    
    @IBOutlet weak var dropdownButton: UIButton!
    
    

    @IBAction func pressedShowDropdown(_ sender: Any) {
        dropDown.show()
    }
    
    
    fileprivate var channelRefHandle: FIRDatabaseHandle?
    fileprivate var channels: [Channel] = []
    var tutorName: String = "Chat"
    var tuteeName: String = "Chat"
    var UID: String = ""
    
    fileprivate lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }

    func displayAlert(_ title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
        
    }
    
    class func instantiateFromStoryboard() -> TutorsTableViewController {
        let storyboard = UIStoryboard(name: "MenuViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! TutorsTableViewController
    }
    
    var dropDown: DropDown = DropDown()
    var segmentIndexIsTutor  = 0
     var segmentItemSubject  = "All Subjects"
    
    let coachMarksController = CoachMarksController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //dbRef = FIRDatabase.database().reference().child("users")
        userRef = FIRDatabase.database().reference().child("users")

        //self.tableView.isEditing = false
        //self.tableView.allowsSelection = true
        
        setupDropDown()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        self.tableView.isUserInteractionEnabled = true
        
        //self.coachMarksController.dataSource = self
        
        //self.tableView.opacity = 0
        
        //self.tableView.backgroundColor = UIColor.clear//clearbackgroundBlue()
        
       // self.tableView.addBackground()
        let titles = ["Tutors", "Students"]
        let frame = CGRect(x: 5, y: 0, width: view.frame.width - 10, height: 40)

        //self.view.backgroundColor = UIColor.backgroundBlue()
        /*let backgroundImageView = UIImageView(image: UIImage(named:"background")!)
        
       let screenWidth = self.view.frame.width
        backgroundImageView.frame = CGRect(x: 0,y: 0, width: screenWidth, height: backgroundImageView.height)
        self.view.backgroundColor = UIColor(patternImage: backgroundImageView)*/
        
        //self.view.addBackground()
        
        self.tableView.backgroundColor = UIColor.clear
        
        FriendSystem.system.getCurrentUser { (user) in
            self.currentUser = user
        }
        
        FriendSystem.system.addUserObserver { () in
            for user in FriendSystem.system.userList {
                if user.isTutor == true {
                    self.finalUserList.append(user)
                    
                }
            }

            self.tableView.reloadData()
        }
        
        FriendSystem.system.friendList.removeAll()
        FriendSystem.system.addFriendObserver {
            for friend in FriendSystem.system.friendList {
                self.friendUserUIDList.append(friend.uid)
            }
        }

        self.view.addFlippedBackground()
        
        let segmentedControl = TwicketSegmentedControl(frame: frame)
        segmentedControl.setSegmentItems(titles)
  
        segmentedControl.delegate = self
        segmentedControl.sliderBackgroundColor = UIColor.sliderGreen()//UIColor.flatBlue
        segmentedControl.backgroundColor = UIColor.clear
        view.addSubview(segmentedControl)
        
                print("finalUserList.count")
        print(finalUserList.count)
       
        tableView.reloadData()
        
        /*if (currentUser?.isTutor) == true {
            segmentedControl.move(to: 1)
        }*/
        
        
        
        //observeChannels()
        
        //startObservingDB()
        
        
    }
    
    var screenBounds = UIScreen.main.bounds
    
   
    func getColoredView() -> UIView{
        let width = screenBounds.size.width
        let height = screenBounds.size.height
        let cellHeight = 135
        let cornerRadius:CGFloat = 5
        let coloredRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: /*Int(self.frame.size.width - 40)*//*Int(width - 20)*/77, height: cellHeight))
        
        
        coloredRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 1.0])
        coloredRoundedView.layer.masksToBounds = false
       // coloredRoundedView.layer.cornerRadius = cornerRadius
        coloredRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        coloredRoundedView.layer.shadowOpacity = 0.2
        
        //leftColorView.backgroundColor = colors[indexPath.row % 6]
        coloredRoundedView.tag = 10
        coloredRoundedView.backgroundColor = colors[colorsCount % 5]
        
        colorsCount += 1
        
        coloredRoundedView.roundCorners(corners: [.topLeft, .bottomLeft], radius: cornerRadius)

        return coloredRoundedView
    }
    
    func setupDropDown() {
        
        
        // The view to which the drop down will appear on
        dropdownButton.layer.cornerRadius = 16
        dropdownButton.layer.width = view.frame.width - 10
        dropdownButton.layer.backgroundColor = UIColor.sliderGreen().cgColor//UIColor.titleBlue().cgColor
        dropDown.anchorView = dropdownButton // UIView or UIBarButtonItem
        dropDown.bottomOffset = CGPoint(x: 0, y: 20)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? SubjectCell else { return }
            
            // Setup your custom UI components
            let currentSubject = subjectNames[index]
            cell.subjectLabel.text = currentSubject
            if let imageName: String = subjectImageNames[currentSubject] {
                cell.subjectImage.image = UIImage(named: "\(imageName)")
            }
        }
        // The list of items to display. Can be changed dynamically
       // dropDown.backgroundColor = UIColor.backgroundBlue()
        dropDown.dataSource = subjectNames//preferredSubj
        dropDown.cellNib = UINib(nibName: "SubjectCell", bundle: nil)
        dropDown.selectionAction = { [unowned self] (index, item) in
            self.dropdownButton.setTitle(item, for: .normal)
            
            self.filterBySubject(item)
        }
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        
        if currentUser?.completedTutorial == false {
        
            self.coachMarksController.startOn(self)
            self.userRef.child((currentUser?.uid)!).child("completedTutorial").setValue(true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.coachMarksController.stop(immediately: true)
    }

    
    
    func startObservingDB () {
        
        if currentUser != nil {
            
            let userCoordinate = currentUser!.coordinate
            let currentUserUID = FIRAuth.auth()?.currentUser?.uid
            
            userRef.observe(.value, with: { (snapshot: FIRDataSnapshot) in
                var newUsers = [User]()
                for user in snapshot.children {
                    
                    var userObject = User(snapshot: user as! FIRDataSnapshot)
                    let coordinate = CLLocation(latitude: userObject.latitude, longitude: userObject.longitude)
                    let isTutor = userObject.isTutor
                    userObject.coordinate = coordinate
                    
                    let distanceBetween = coordinate.distance(from: userCoordinate)
                    userObject.distanceFromUser = distanceBetween
                    if distanceBetween <= 50000  {
                        if (self.currentUser?.isTutor == true && isTutor == false) ||
                            (self.currentUser?.isTutor == false && isTutor == true) {
                            if userObject.uid != currentUserUID {
                                newUsers.append(userObject)
                            }
                        }
                    }
                }
                    
                    self.tutors = newUsers
                    self.tableView.reloadData()
            }) { (error: Error) in
                print("inside error")
                print(error)
            }
        }
    }
    
    
    
    func didSelect(_ segmentIndex: Int) {
        self.segmentIndexIsTutor = segmentIndex
        finalFilter(segmentIndexIsTutor: self.segmentIndexIsTutor, segmentItemSubject: self.segmentItemSubject)
        /*switch segmentIndex {
        case 0: //tutors
            finalUserList.removeAll()
            for user in FriendSystem.system.userList {
                if user.isTutor == true {
                    
                    finalUserList.append(user)
                    
                }
            }
                        tableView.reloadData()
        case 1: //students
            finalUserList.removeAll()
            for user in FriendSystem.system.userList {
                if user.isTutor != true {
                    finalUserList.append(user)
                    
                }
            }
            tableView.reloadData()
        case 2: //everyone
         
            finalUserList = FriendSystem.system.userList
            tableView.reloadData()
        default:
           
            finalUserList = FriendSystem.system.userList
            tableView.reloadData()
        }*/
        
    }
    
    func filterBySubject(_ segmentItem: String) {
        self.segmentItemSubject = segmentItem
        finalFilter(segmentIndexIsTutor: self.segmentIndexIsTutor, segmentItemSubject: self.segmentItemSubject)
        /*if segmentItem == "All Subjects" {
            self.didSelect(dropDown.indexForSelectedRow!)
        } else {
            finalUserList = [User]()
            for user in FriendSystem.system.userList {
                for subject in user.preferredSubjects {
                    if subject == segmentItem {
                        finalUserList.append(user)
                    }
                }
            }
            tableView.reloadData()
        }*/

    }
    
    func finalFilter(segmentIndexIsTutor: Int, segmentItemSubject: String) {
    
        /*if segmentItemSubject == "All Subjects" {
            //self.didSelect(dropDown.indexForSelectedRow!)
        } else {*/
            finalUserList = [User]()
            for user in FriendSystem.system.userList {
                for subject in user.preferredSubjects {
                    if (subject == segmentItemSubject || segmentItemSubject == "All Subjects")  && ((segmentIndexIsTutor == 0 && user.isTutor == true) || (segmentIndexIsTutor == 1 && user.isTutor == false)) {
                        finalUserList.append(user)
                    }
                }
            }
            tableView.reloadData()
        //}
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return tutors.count
        
        return finalUserList.count
    }
    
    
    let coachMarkArray = [CoachMark]()
    
    let coachMark1 = CoachMarkInfo(title: "Add a Friend", content: "Click this button to add this person to your contact list")
    let coachMark2 = CoachMarkInfo(title: "Added Friend", content: "This circle will turn green if you have already added this person as a friend. ")
   // let coachMark2 = CoachMarkInfo(title: "Added Friend", content: "This circle will turn green if you have already added this person as a friend. ")

    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }
    
    
    
    /// Asks for the metadata of the coach mark that will be displayed in the
    /// given nth place. All `CoachMark` metadata are optional or filled with
    /// sensible defaults. You are not forced to provide the `cutoutPath`.
    /// If you don't the coach mark will be dispayed at the bottom of the screen,
    /// without an arrow.
    ///
    /// - Parameter coachMarksController: the coach mark controller requesting
    ///                                   the information.
    /// - Parameter coachMarkViewsForIndex: the index referring to the nth place.
    ///
    /// - Returns: the coach mark metadata.
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        return coachMarksController.helper.makeCoachMark(for: self.dropdownButton)
    }
    
    /// Asks for the views defining the coach mark that will be displayed in
    /// the given nth place. The arrow view is optional. However, if you provide
    /// one, you are responsible for supplying the proper arrow orientation.
    /// The expected orientation is available through
    /// `coachMark.arrowOrientation` and was computed beforehand.
    ///
    /// - Parameter coachMarksController: the coach mark controller requesting
    ///                                   the information.
    /// - Parameter coachMarkViewsForIndex: the index referring to the nth place.
    /// - Parameter coachMark: the coach mark meta data.
    ///
    /// - Returns: a tuple packaging the body component and the arrow component.
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        coachViews.bodyView.hintLabel.text = "Hello! I'm a Coach Mark!"
        coachViews.bodyView.nextLabel.text = "Ok!"
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }

    @IBAction func createNewChat(_ sender: Any) {
        /*if let uid = (sender as AnyObject).accessibilityIdentifier {
            
            createChannel(otherUser: uid!)
        }*/
        let userID = FIRAuth.auth()?.currentUser?.uid
        print("create new Chat")
        /*channelRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let user = User.init(username: username)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }*/
        var finishedObserve = false
        
        if let uid = (sender as AnyObject).accessibilityIdentifier {
            print(uid)
            channelRef.observe(FIRDataEventType.value, with: { (snapshot) in
                print("in observe")
                let value = snapshot.value as? [String : AnyObject] ?? [:]
                if let tuteeName = value["tuteeName"] as? String,
                    let tutorName = value["tutorName"] as? String {
                    if (userID == tuteeName  && uid == tutorName) ||
                        (userID == tutorName && uid == tuteeName) {
                        self.newChannel = Channel(id: snapshot.key, name: "Chat", tutorName: tutorName, tuteeName: tuteeName)
                        let userDefaults = UserDefaults.standard
                         finishedObserve = true
                        if let userName = userDefaults.value(forKey: "name") as? String {
                            
                            print(" if let userName = userDefaults.value(forKey: ) as? String {")
                           
                            self.senderDisplayName = userID
                        } else {
                            self.senderDisplayName = FIRAuth.auth()?.currentUser?.email
                        }
                        
                        
                        self.performSegue(withIdentifier: "toChatVC", sender: self.newChannel)
                        
                    }
                }
                
            })
            if finishedObserve == false {
                print("finishedObserve == false")
               //createChannel(uid!)
            }
        }
        
       
        
        
    }
    
    
    
    func createChannel(_ otherUser: User) {
        
        
        
        /*let userDefaults = UserDefaults.standard
         if let isTutor = userDefaults.value(forKey: "isTutor") as? Bool,
         let userName = userDefaults.value(forKey: "name") as? String {
         }
         }*/
        let userDefaults = UserDefaults.standard
       // let isTutor = userDefaults.value(forKey: "isTutor") as? Bool
        let isTutor = FriendSystem.system.currentUser?.isTutor
        
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            
            if isTutor == true {
                tutorName = userID
                tuteeName = otherUser.uid
            } else {
                tutorName = otherUser.uid
                tuteeName = userID
            }
        } else {
            tutorName = "Chat"
            tuteeName = "Chat"
        }
        
        
        
       // let newCalendarId = createCalendar(destUser: otherUser)

        let channelItem = [
            "tutorName": tutorName,
            "tuteeName": tuteeName,
           // "calendarId": newCalendarId
        ]
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        

        
        let uuid = UUID().uuidString
        self.newChannel = Channel(id: uuid, name: channelItem["tutorName"]!, tutorName: tutorName, tuteeName: tuteeName)
        if let userName = userDefaults.value(forKey: "name") as? String {
        
            self.senderDisplayName = userID
        } else {
            self.senderDisplayName = FIRAuth.auth()?.currentUser?.email
        }
        

        let userChannelRef = userRef.child(userID!).child("channels")
        let newChannelRef = channelRef.child(uuid)
        newChannelRef.setValue(channelItem)
        
        //This sets the channel item in the child "channels"
        userChannelRef.child(uuid).child("tutorName").setValue(tutorName)
        userChannelRef.child(uuid).child("tuteeName").setValue(tuteeName)
      //  userChannelRef.child(uuid).child("calendarId").setValue(newCalendarId)
        
        //This adds the other user as a "friend" child to the current user ref and vice versa
        FriendSystem.system.acceptFriendRequest(otherUser.uid)
        
       // self.performSegue(withIdentifier: "toChatVC", sender: self.newChannel)
        
    }
    
    //This function creates a new calendar identifier to add to a newly created channel
  /*  func createCalendar(destUser: User) -> String {
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        let userChannelRef = userRef.child(userID!).child("channels")
        
        let channelRef = FIRDatabase.database().reference()
        
        let eventStore = EKEventStore()
        //let initCalendar = EKCalendar()
        //let eventCalendar = initCalendar.calendar
        
        // Use Event Store to create a new calendar instance
        // Configure its title
        var newCalendar = EKCalendar(for: .event, eventStore: eventStore)
        
        //var newCalendar = eventStore.calendar
        // newCalendar.calendarIdentifier = identifier
        // Probably want to prevent someone from saving a calendar
        // if they don't type in a name...
      
        if currentUser != nil {
            newCalendar.title = "Events (\(destUser.name) & \(currentUser!.name))"
        }
        
        
        // Access list of available sources from the Event Store
        let sourcesInEventStore = eventStore.sources
        
        // Filter the available sources and select the "Local" source to assign to the new calendar's
        // source property
        newCalendar.source = sourcesInEventStore.filter{
            (source: EKSource) -> Bool in
            source.sourceType.rawValue == EKSourceType.local.rawValue
            }.first!
        
        //channelRef.child("calendarId").setValue(newCalendar.calendarIdentifier)
        //userChannelRef.child("calendarId").setValue(newCalendar.calendarIdentifier)
        
        //self.calendars.append(newCalendar)
        
        do {
            try eventStore.saveCalendar(newCalendar, commit: true)
            //UserDefaults.standardUserDefaults().setObject(newCalendar.calendarIdentifier, forKey: "EventTrackerPrimaryCalendar")
        } catch {
          //  displayAlert("Unab", message: <#T##String#>)
        }
        
        return newCalendar.calendarIdentifier
        
    }
*/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("in did select")
        //tableView.deselectRow(at: indexPath, animated: true)
        //your code...
        /*var selectedCell:UserCellThree = tableView.cellForRow(at: indexPath)! as! UserCellThree
        selectedCell.contentView.backgroundColor = UIColor.clear*/
        
        let userAtRow = finalUserList[indexPath.row]
        
        let tutor = userAtRow
        self.UID = tutor.uid
        self.destinationUser = tutor
        self.performSegue(withIdentifier: "toMoreInfoVC", sender: self)
        
    }

 

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        // Create cell
        //var cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCellThree
        
        
            tableView.register(UINib(nibName: "UserCellThree", bundle: nil), forCellReuseIdentifier: "UserCell")
           var cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCellThree
        
        /*let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell?.selectedBackgroundView = backgroundView*/
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
       var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
       
       //cell?.alpha = 0
        // Modify cell
        //let userAtRow = FriendSystem.system.userList[indexPath.row]
        let userAtRow = finalUserList[indexPath.row]
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        /*if userAtRow.profileImageUrl != nil {
            print("if userAtRow.profileImageUrl != nil {")
            if URL(string: userAtRow.profileImageUrl!) != nil {
                print("if URL(string: userAtRow.profileImageUrl!) != nil {")
                cell!.profileImageView.loadImageUsingCacheWithUrlString(userAtRow.profileImageUrl!)
            } else {
                cell!.profileImageView.image = #imageLiteral(resourceName: "Owl Icon")
            }
        } else {
            cell!.profileImageView.image = #imageLiteral(resourceName: "Owl Icon")
        }*/
        
        //cell!.layer.cornerRadius = 10
        cell?.contentView.backgroundColor = UIColor.clear
        
               
        
        //let colorIndex = Int(arc4random_uniform(5))
        //cell!.colorView.backgroundColor = colors[indexPath.row % 5]
        
        let friendInArray = friendUserUIDList.doesContain(obj: userAtRow.uid)
        if friendInArray == true {
            cell!.friendIndicatorView.image = UIImage(named: "Ok-50") //UIColor.green
        } else {
            cell!.friendIndicatorView.image = nil
        }
        
        /*if userAtRow.isTutor == false {
            cell!.addSubview(getColoredView())
        } else {
            if let viewWithTag = self.view.viewWithTag(10) {
                print("Tag 100")
                viewWithTag.removeFromSuperview()
            }
            if let viewWithTag2 = self.view.viewWithTag(10) {
                print("Tag 100")
                viewWithTag2.removeFromSuperview()
            }
            if let viewWithTag3 = self.view.viewWithTag(10) {
                print("Tag 100")
                viewWithTag3.removeFromSuperview()
            }
        }*/
       /* if FriendSystem.system.friendList.contains(where: userAtRow) {
            cell!.friendIndicatorView.backgroundColor = UIColor.green
        } else {
            cell!.friendIndicatorView.backgroundColor = UIColor.clear
        }*/

        
        
        /*if friendInArray {
            cell!.friendIndicatorView.backgroundColor = UIColor.green
        } else {
             cell!.friendIndicatorView.backgroundColor = UIColor.clear
        }*/

        
        cell!.nameLabel.text = "\(userAtRow.name)"
        cell!.schoolLabel.text = "\(userAtRow.school)"
        cell!.gradeLabel.text = "\(userAtRow.grade)"
        if let userAverageRating = userAtRow.averageRating {
            cell!.ratingView.rating = userAverageRating
        } else {
            cell!.ratingView.rating = 0
        }
        
        let numberOfRatings = userAtRow.numberOfRatings
        var numberOfRatingsString = "\(String(describing: numberOfRatings)) ratings"
        if numberOfRatings == 1 {
            numberOfRatingsString = "\(String(describing: numberOfRatings)) rating"
        }
        cell!.numberOfRatingsLabel.text = numberOfRatingsString
        
        if userAtRow.gpa != nil && userAtRow.gpa > 0 {
            let gpaString = String(format: "%.1f", userAtRow.gpa)
            cell!.gpaLabel.text = gpaString
        } else {
            cell!.gpaLabel.text = ""
        }
        if userAtRow.hourlyPrice != nil && userAtRow.hourlyPrice > 0 {
            let hourlyPriceString = String(format: "%.0f", userAtRow.hourlyPrice)
            cell!.hourlyPriceLabel.text = "$" + hourlyPriceString
        }
       // cell!.chatButton.accessibilityIdentifier = userAtRow.uid
        
        
        let subjectsString = userAtRow.preferredSubjects.joined(separator: ", ")
        //print(subjectsString)
        
        if subjectsString != nil && cell!.subjectLabel != nil{
            cell!.subjectLabel.text = "\(subjectsString)"
        } else {
           // cell!.subjectLabel.text = ""
        }
        
        
        print("Name: \(userAtRow.name)")
        print(cell!.nameLabel.text)
        cell!.infoButton.contentMode = .scaleAspectFit
        cell!.addFriendButton.contentMode = .scaleAspectFit
        
        
        print("in cell for row")
        cell!.setAddFriendFunction {
            print(userAtRow)
            let id = userAtRow.uid
            print("userAtRow.uid \(id)")
            //FriendSystem.system.sendRequestToUser(id)
            FriendSystem.system.acceptFriendRequest(id)
            self.createChannel(userAtRow)
            self.displayAlert("Success!", message: "Contact Added")
        }
      /*  cell!.setChatFunction {
            self.createChannel(userAtRow.uid)
        }*/
        cell!.setInfoFunction {
            let tutor = userAtRow
            self.UID = tutor.uid
            self.destinationUser = tutor
            self.performSegue(withIdentifier: "toMoreInfoVC", sender: self)
        }
        
        // Return cell
        return cell!
    }
    
    
    /*func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        /*let tutor = tutors[indexPath.row]
        UID = tutor.uid
        destinationUser = tutor
        self.performSegue(withIdentifier: "toMoreInfoVC", sender: self)*/
    }*/
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        print("in prepare for segue")
       if segue.identifier == "toChatVC" {
        
                print("toChatVC")
                if let channel = sender as? Channel {
                    print("in if let")
                    
                    let chatVc = segue.destination as! ChatViewController
                    
                    chatVc.senderDisplayName = senderDisplayName
                    chatVc.channel = channel
                    chatVc.channelRef = channelRef.child(channel.id)
                }
       } else if segue.identifier == "toMoreInfoVC" {
        print("toMoreInfoVC")
        let moreInfoVC = segue.destination as! MoreInfoViewController
        
        moreInfoVC.UID = UID
        //moreInfoVC.indexPathRow = indexPath.row
        moreInfoVC.destUser = destinationUser
        
    }
        

        
        
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.0)
    }
    
    fileprivate func observeChannels() {
        // We can use the observe method to listen for new
        // channels being written to the Firebase DB
        var tutorOrTutee = "tutorName"
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
            if let channelData = snapshot.value as? Dictionary<String, AnyObject> {
                let id = snapshot.key
                var ref: FIRDatabaseReference!
                let userID = FIRAuth.auth()?.currentUser?.uid
                ref = FIRDatabase.database().reference()
                ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let userObject = User(snapshot: snapshot )
                    
                    let value = snapshot.value as? NSDictionary
                    let isTutor = userObject.isTutor
                    
                    if isTutor != nil {
                        if isTutor == true {
                            tutorOrTutee = "tuteeName"
                        } else {
                            tutorOrTutee = "tutorName"
                        }
                    }
                    else {
                        // no highscore exists
                    }
                    
                    
                    if let name = channelData[tutorOrTutee] as! String!, name.characters.count > 0 {
                        self.channels.append(Channel(id: id, name: "Chat", tutorName: channelData["tutorName"] as! String, tuteeName: channelData["tuteeName"] as! String))
                        self.tableView.reloadData()
                    } else {
                        print("Error! Could not decode channel data")
                    }
                })
            }
                
        })
    }
    
    //If the user scrolls to the bottom of the tableView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            //log if the user scrolls to bottom
            if currentUser != nil {
                print("logged scroll to bottom")
            FIRAnalytics.logEvent(withName: "scrolled_to_bottom", parameters: [
                "current_user": currentUser!.uid as NSObject,
                "current_user_is_tutor": currentUser!.isTutor as NSObject
                ])
            }
        }
    }
    /* EmptyDataSet */
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No Users to Display"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),NSForegroundColorAttributeName : UIColor.white ]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "There are no nearby users at this time.  Please try again later."
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body), NSForegroundColorAttributeName : UIColor.white]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "placeholder_kickstarter")
    }
    
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
/*
 func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
 let str = "Add Grokkleglob"
 let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)]
 return NSAttributedString(string: str, attributes: attrs)
 }
 
 func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
 let ac = UIAlertController(title: "Button tapped!", message: nil, preferredStyle: .alert)
 ac.addAction(UIAlertAction(title: "Hurray", style: .default))
 present(ac, animated: true)
 }*/

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
