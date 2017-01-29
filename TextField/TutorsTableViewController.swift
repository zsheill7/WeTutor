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


class TutorsTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    var dbRef: FIRDatabaseReference!
    var tutors = [User]()
    var userRef: FIRDatabaseReference!
    var senderDisplayName: String?
    var newChannel: Channel?
    var destinationUser: User!
    var currentUser: User?
    
    private var channelRefHandle: FIRDatabaseHandle?
    private var channels: [Channel] = []
    var tutorName: String = "Chat"
    var tuteeName: String = "Chat"
    var UID: String = ""
    
    private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }

    func displayAlert(title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
        
    }
    
    class func instantiateFromStoryboard() -> TutorsTableViewController {
        let storyboard = UIStoryboard(name: "MenuViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! TutorsTableViewController
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
       
       // self.view.addBackground(imageName: "mixed2")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        FriendSystem.system.getCurrentUser { (user) in
           self.currentUser = user
        }
        FriendSystem.system.addUserObserver { () in
            self.tableView.reloadData()
        }
        
        observeChannels()
        dbRef = FIRDatabase.database().reference().child("users")
        userRef = FIRDatabase.database().reference().child("users")
        startObservingDB()
        
        
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
                    userObject.coordinate = coordinate
                    
                    let distanceBetween = coordinate.distance(from: userCoordinate)
                    userObject.distanceFromUser = distanceBetween
                    if distanceBetween <= 50000 {
                        if userObject.uid != currentUserUID {
                            newUsers.append(userObject)
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
        return FriendSystem.system.userList.count
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
                createChannel(otherUser: uid!)
            }
        }
        
       
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    /*func createChannel(otherUser: String) {
        print("in create channel")
        let userDefaults = UserDefaults.standard
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        print(userID)
        var ref: FIRDatabaseReference!
        let user = FIRAuth.auth()?.currentUser
        
        ref = FIRDatabase.database().reference()
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            print("in child observesingleevent")
            let userObject = User(snapshot: snapshot )
            print(userObject)
            let value = snapshot.value as? NSDictionary
            let isTutor = userObject.isTutor
            
            if isTutor != nil {
                print("tutor != nil")
                
                    if isTutor == true {
                        self.tutorName = userID!
                        self.tuteeName = otherUser
                    } else {
                        
                    }
            } else {
                self.tutorName = "Chat"
                self.tuteeName = "Chat"
            }
         
            print("Tutor Name: " + self.tutorName)
            print("Tutee Name: " + self.tuteeName)
            
        
                let uuid = UUID().uuidString
            let channelItem = [
                "tutorName": self.tutorName,
                "tuteeName": self.tuteeName
            ]
           
            self.newChannel = Channel(id: uuid, name: channelItem["tutorName"]!)
          
            let newChannelRef = self.channelRef.childByAutoId()
            
            newChannelRef.setValue(channelItem)
            let userID = FIRAuth.auth()?.currentUser?.uid
            let userChannelRef = self.userRef.child(userID!).child("channels")
            userChannelRef.setValue(channelItem)
            /*userChannelRef.child("tutorName").setValue(self.tutorName)
            userChannelRef.child("tuteeName").setValue(tuteeName)*/
                self.performSegue(withIdentifier: "toChatVC", sender: self.newChannel)

            

        })
        
        
    }*/
    func createChannel(otherUser: String) {
        
        
        
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
                tuteeName = otherUser
            } else {
                
            }
        } else {
            tutorName = "Chat"
            tuteeName = "Chat"
        }

        let channelItem = [
            "tutorName": tutorName,
            "tuteeName": tuteeName
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
        userChannelRef.child(uuid).child("tutorName").setValue(tutorName)
        userChannelRef.child(uuid).child("tuteeName").setValue(tuteeName)
        
        FriendSystem.system.acceptFriendRequest(otherUser)
        
        self.performSegue(withIdentifier: "toChatVC", sender: self.newChannel)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 161.0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UserCell {
       /* let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserCell
        
        print("in cell for row")
        let tutor = tutors[indexPath.row]
        cell.nameLabel?.text = tutor.name
        cell.schoolLabel?.text = tutor.school
        cell.gradeLabel?.text = "Age:" + String(tutor.age)
        cell.accessoryType = .detailDisclosureButton
        
        // Configure the cell...

        return cell*/
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        if cell == nil {
            tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        }
        /*print("Name: \(FriendSystem.system.userList[indexPath.row].name)")
        print("School: \(FriendSystem.system.userList[indexPath.row].school)")
         print("Email: \(FriendSystem.system.userList[indexPath.row].email)")
        print(FriendSystem.system.userList[indexPath.row].grade)*/
        // Modify cell
        cell!.nameLabel.text = "Name: \(FriendSystem.system.userList[indexPath.row].name)"
        cell!.schoolLabel.text = "School: \(FriendSystem.system.userList[indexPath.row].school)"
        cell!.gradeLabel.text = "Grade: \(FriendSystem.system.userList[indexPath.row].grade)"
        cell!.chatButton.accessibilityIdentifier = FriendSystem.system.userList[indexPath.row].uid
        
        
        cell!.setAddFriendFunction {
            print(FriendSystem.system.userList[indexPath.row])
            let id = FriendSystem.system.userList[indexPath.row].uid
            print(id)
            FriendSystem.system.sendRequestToUser(id)
            self.displayAlert(title: "Success!", message: "Friend Request Sent")
        }
        cell!.setChatFunction {
            self.createChannel(otherUser: FriendSystem.system.userList[indexPath.row].uid)
        }
        cell!.setInfoFunction {
            let tutor = FriendSystem.system.userList[indexPath.row]
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
    
    private func observeChannels() {
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
