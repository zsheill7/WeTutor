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


class TutorsTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, TwicketSegmentedControlDelegate {

    var dbRef: FIRDatabaseReference!
    var tutors = [User]()
    var userRef: FIRDatabaseReference!
    var senderDisplayName: String?
    var newChannel: Channel?
    var destinationUser: User!
    var currentUser: User?
    
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
    var segmentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference().child("users")
        userRef = FIRDatabase.database().reference().child("users")

        setupDropDown()
        
        let titles = ["Tutors", "Students", "Everyone"]
        let frame = CGRect(x: 5, y: 0, width: view.frame.width - 10, height: 40)

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

        let segmentedControl = TwicketSegmentedControl(frame: frame)
        segmentedControl.setSegmentItems(titles)
  
        segmentedControl.delegate = self
        
        view.addSubview(segmentedControl)
        
                print("finalUserList.count")
        print(finalUserList.count)
       
        tableView.reloadData()
        
        if (currentUser?.isTutor) == true {
            segmentedControl.move(to: 1)
        }
        
        
        
        //observeChannels()
        
        //startObservingDB()
        
        
    }
    
   
    
    func setupDropDown() {
        
        
        // The view to which the drop down will appear on
        dropDown.anchorView = dropdownButton // UIView or UIBarButtonItem
        dropDown.bottomOffset = CGPoint(x: 0, y: 20)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? SubjectCell else { return }
            
            // Setup your custom UI components
            let currentSubject = subjectNames[index]
            cell.subjectLabel.text = currentSubject
            if let imageName: String = subjectImageNames[currentSubject] {
                cell.subjectImage.image = UIImage(named: "\(imageName)-1")
            }
        }
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = subjectNames//preferredSubj
        dropDown.cellNib = UINib(nibName: "SubjectCell", bundle: nil)
        dropDown.selectionAction = { [unowned self] (index, item) in
            self.dropdownButton.setTitle(item, for: .normal)
            
            self.filterBySubject(item)
        }
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        
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
    
    var finalUserList = [User]()
    
    func didSelect(_ segmentIndex: Int) {
        self.segmentIndex = segmentIndex
        switch segmentIndex {
        case 0: //tutors
            finalUserList = [User]()
            for user in FriendSystem.system.userList {
                if user.isTutor == true {
                    finalUserList.append(user)
                    
                }
            }
            tableView.reloadData()
        case 1: //students
            finalUserList = [User]()
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
        }
        
    }
    
    func filterBySubject(_ segmentItem: String) {
        if segmentItem == "All Subjects" {
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
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return tutors.count
        
        return finalUserList.count
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
        let isTutor = userDefaults.value(forKey: "isTutor") as? Bool
        
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
        
        
        
        let newCalendarId = createCalendar(destUser: otherUser)

        let channelItem = [
            "tutorName": tutorName,
            "tuteeName": tuteeName,
            "calendarId": newCalendarId
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
        userChannelRef.child(uuid).child("calendarId").setValue(newCalendarId)
        
        //This adds the other user as a "friend" child to the current user ref and vice versa
        FriendSystem.system.acceptFriendRequest(otherUser.uid)
        
       // self.performSegue(withIdentifier: "toChatVC", sender: self.newChannel)
        
    }
    
    //This function creates a new calendar identifier to add to a newly created channel
    func createCalendar(destUser: User) -> String {
        
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UserCellTwo {
      
        
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCellTwo
        if cell == nil {
            tableView.register(UINib(nibName: "UserCellTwo", bundle: nil), forCellReuseIdentifier: "UserCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCellTwo
        }
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
       
       
        // Modify cell
        //let userAtRow = FriendSystem.system.userList[indexPath.row]
        let userAtRow = finalUserList[indexPath.row]
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        if userAtRow.profileImageUrl != nil {
            print("if userAtRow.profileImageUrl != nil {")
            if URL(string: userAtRow.profileImageUrl!) != nil {
                print("if URL(string: userAtRow.profileImageUrl!) != nil {")
                cell!.profileImageView.loadImageUsingCacheWithUrlString(userAtRow.profileImageUrl!)
            } else {
                cell!.profileImageView.image = #imageLiteral(resourceName: "Owl Icon-2")
            }
        } else {
            cell!.profileImageView.image = #imageLiteral(resourceName: "Owl Icon-2")
        }
        
        cell!.nameLabel.text = "\(userAtRow.name)"
        cell!.schoolLabel.text = "School: \(userAtRow.school)"
        cell!.gradeLabel.text = "Grade: \(userAtRow.grade)"
       // cell!.chatButton.accessibilityIdentifier = userAtRow.uid
        
        
        let subjectsString = userAtRow.preferredSubjects.joined(separator: ", ")
        cell!.subjectLabel.text = "Subjects: \(subjectsString)"
        
        
        print("Name: \(userAtRow.name)")
        print(cell!.nameLabel.text)
        cell!.infoButton.contentMode = .scaleAspectFit
        cell!.addFriendButton.contentMode = .scaleAspectFit
        
        
        cell!.setAddFriendFunction {
            print(userAtRow)
            let id = userAtRow.uid
            print(id)
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
    
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        /*let tutor = tutors[indexPath.row]
        UID = tutor.uid
        destinationUser = tutor
        self.performSegue(withIdentifier: "toMoreInfoVC", sender: self)*/
    }
    
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
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
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
    /* EmptyDataSet */
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No Users to Display"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "There are no nearby users at this time.  Please try again later."
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "placeholder_kickstarter")
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
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
