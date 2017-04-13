/*
 * Copyright (c) 2017 Zoe Sheill
 *
 */

import UIKit
import Firebase
import SCLAlertView

enum Section1: Int {
    case createNewChannelSection = 0
    case currentChannelsSection
}

class AddEventChannelListViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UISearchBarDelegate {
    
   // @IBOutlet weak var searchBar: UISearchBar!
    var filteredData: [User]!
    
    let cellId = "ChatUserCell"
    // MARK: Properties
    
   // @IBOutlet weak var backButton: UIBarButtonItem!
   
    var senderDisplayName: String?
    var newChannelTextField: UITextField?
    var dbRef: FIRDatabaseReference!
    var tutors = [User]()
    fileprivate var channelRefHandle: FIRDatabaseHandle?
    fileprivate var channels: [Channel] = []
    var tutorName: String = ""
    var tuteeName: String = ""
    var tutorOrTutee = "tutorName"
    var currentUserIsTutor = false
    var iterationStatus = ""
    
    var currentUser: User!
    fileprivate lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")
    
    var userRef = FIRDatabase.database().reference().child("users")
    
    
    // MARK: View Lifecycle
    
    func displayAlert(_ title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
        
    }
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet var backNavigationItem: UINavigationItem!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderDisplayName = "User"
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        // searchBar.delegate = self
        //self.view.addBackground()
        
       
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            userRef.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let userObject = User(snapshot: snapshot )
                print("userRef.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in")
                
                // let value = snapshot.value as? NSDictionary
                let isTutor = userObject.isTutor
                let displayName = userObject.name
                self.senderDisplayName = displayName
                
                print("self.senderDisplayName")
                print(self.senderDisplayName ?? "")
                
                if isTutor == true {
                    self.tutorOrTutee = "tuteeName"
                    self.currentUserIsTutor = true
                } else {
                    self.currentUserIsTutor = false
                    self.tutorOrTutee = "tutorName"
                }
                
                
            })
        }
        // title = "RW RIC"
        
        
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonPressed))
        FriendSystem.system.getCurrentUser { (user) in
            //self.usernameLabel.text = user.email
        }
        /*FriendSystem.system.addUserObserver { () in
         self.tableView.reloadData()
         }*/
        FriendSystem.system.addFriendObserver {
            print("FriendSystem.system.friendList  \(FriendSystem.system.friendList)")
            self.tableView.reloadData()
            // self.observeChannels()
        }
        
        tableView.register(ChatUserCell.self, forCellReuseIdentifier: cellId)
        self.tableView.reloadData()
        if FriendSystem.system.friendList.count != 0 {
            //self.view.addBackground()
        }
        //filteredData = FriendSystem.system.friendList
        
        dbRef = FIRDatabase.database().reference().child("users")
        userRef = FIRDatabase.database().reference().child("users")
        //startObservingDB()
        
    }
    
    func startObservingDB () {
        
        dbRef.observe(.value, with: { (snapshot: FIRDataSnapshot) in
            var newUsers = [User]()
            for user in snapshot.children {
                let userObject = User(snapshot: user as! FIRDataSnapshot)
                newUsers.append(userObject)
            }
            self.tutors = newUsers
            self.tableView.reloadData()
        }) { (error: Error) in
            
            print("inside error")
            print(error)
            
        }
    }
    
    // i'm having trouble deciding a couple things.  input would be great
    //for an app designed to connect tutors and students, is a built-in calendar necessary
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }
    
    // MARK :Actions
    
    @IBAction func createChannel(_ sender: AnyObject) {
        //createChannel()
    }
    
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
                tutorName = otherUser
                tuteeName = userID
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
        let userChannelRef = userRef.child(userID!).child("channels")
        let uuid = UUID().uuidString
        let newChannelRef = channelRef.child(uuid)
        newChannelRef.setValue(channelItem)
        userChannelRef.child(uuid).child("tutorName").setValue(tutorName)
        userChannelRef.child(uuid).child("tuteeName").setValue(tuteeName)
        
        //channelRef.child(uuid).setValue(
        
    }
    
    /*func createChannelTemp(otherUser: String) {
     
     
     
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
     
     let newChannelRef = channelRef.childByAutoId()
     let channelItem = [
     "tutorName": tutorName,
     "tuteeName": tuteeName
     ]
     newChannelRef.setValue(channelItem)
     let userID = FIRAuth.auth()?.currentUser?.uid
     let userChannelRef = userRef.child(userID!).child("channels")
     let uuid = UUID().uuidString
     
     userChannelRef.child(uuid).child("tutorName").setValue(tutorName)
     userChannelRef.child(uuid).child("tuteeName").setValue(tuteeName)
     
     }*/
    
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
     
     //self.createChannel = Channel(id: uuid, name: channelItem["tutorName"]!)
     
     let newChannelRef = self.channelRef.childByAutoId()
     
     newChannelRef.setValue(channelItem)
     let userID = FIRAuth.auth()?.currentUser?.uid
     let userChannelRef = self.userRef.child(userID!).child("channels")
     userChannelRef.setValue(self.channelRef)
     /*userChannelRef.child("tutorName").setValue(self.tutorName)
     userChannelRef.child("tuteeName").setValue(tuteeName)*/
     self.performSegue(withIdentifier: "toChatVC", sender: self)
     
     
     
     })
     
     
     }*/
    
    // MARK: Firebase related methods
    
    
    fileprivate func observeChannels() {
        // We can use the observe method to listen for new
        // channels being written to the Firebase DB
        
        self.channels.removeAll()
        
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
                
                let value = snapshot.value as? NSDictionary
                let isTutor = userObject.isTutor
                if isTutor != nil {
                    if isTutor == true {
                        self.currentUserIsTutor = true
                        self.tutorOrTutee = "tuteeName"
                    } else {
                        self.currentUserIsTutor = false
                        self.tutorOrTutee = "tutorName"
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
                    
                    self.channels.append(channel)
                    self.tableView.reloadData()
                    
                }
            })
        }
        /*userRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot1) in
         
         if snapshot1.hasChild("channels") {
         
         let channelRefHandle = userChannelRef.observe(.childAdded, with: { (snapshot) -> Void in
         //let channelData = snapshot.value as! Dictionary<String, AnyObject>
         if let channelData = snapshot.value as? Dictionary<String, AnyObject> {
         print("  if let channelData = snapshot.value as? Dictionary<String, AnyObject> {")
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
         })
         
         if let name = channelData[tutorOrTutee] as! String!, name.characters.count > 0 {
         print(" if let name = channelData[tutorOrTutee] as! String!, name.characters.count > 0 {")
         self.channels.append(Channel(id: id, name: name))
         self.tableView.reloadData()
         } else {
         print("Error! Could not decode channel data")
         }
         }
         })
         } else {
         print("false room doesn't exist")
         }
         })*/
    }
    
    /* MARK: EmptyDataSet */
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No Contacts to Display"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Find tutors and students to connect with"
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
     }
     */
    // MARK: Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // super.prepare(for: segue, sender: sender)
        
        //if segue.identifier == "toChatVC" {
        if let channel = sender as? Channel {
            let addEventVC = segue.destination as! AddEventViewController
            
            print("senderdisplayName")
            print(senderDisplayName)
            print("channelRef1")
            print(channelRef.child(channel.id))
            //addEventVC.senderDisplayName = senderDisplayName!
            addEventVC.channel = channel
            addEventVC.channelRef = channelRef.child(channel.id)
        }
        // }
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
   func backButtonPressed() {
        let storyboard = UIStoryboard(name: "Tutor", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "tutorPagingMenuNC") as! UINavigationController
        //controller.modalTransitionStyle = .flipHorizontal
        self.present(controller, animated: true, completion: nil)
    }
   
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return tutors.count
        print("FriendSystem.system.friendList.count \(FriendSystem.system.friendList.count)")
        print(FriendSystem.system.friendList.count)
        //print(filteredData.count)
        return FriendSystem.system.friendList.count
        
    }
    
    //Talking to administrators
    //Bad words or meanness
    //Teachers can't text students
    //Teacher would be able to recommend the app?
    //See if admins think this is a good idea
    
    
    let cellHeight: CGFloat = 90.0
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ChatUserCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatUserCell
        
        let user = FriendSystem.system.friendList[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            if URL(string: user.profileImageUrl!) != nil {
                cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            } else {
                cell.profileImageView.image = #imageLiteral(resourceName: "Owl Icon")
            }
        } else {
            cell.profileImageView.image = #imageLiteral(resourceName: "Owl Icon")
        }
        
        return cell
        
        
        // Return cell
        //return cell!
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //self.performSegue(withIdentifier: "ShowChannel", sender: self)
        
        /*if (indexPath as NSIndexPath).section == Section1.currentChannelsSection.rawValue {*/
        //
        
        //To see if a user started a chat with someone on their friends list
        if currentUser != nil {
            FIRAnalytics.logEvent(withName: "did_select_chat", parameters: [
                "current_user": currentUser.uid as NSObject,
                "current_user_is_tutor": currentUserIsTutor as NSObject
                ])
        }
        
        let destUser = FriendSystem.system.friendList[indexPath.row]
        let destUserID = destUser.uid
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
                            
                            
                            //print(" if let channel = snapshot.value as? [String: String] {")
                            //This iterates through the channel list and checks if either the tutorName or the tutorName is equal to the current user
                            
                            if self.currentUserIsTutor == false {
                                if let tuteeName = channelDict["tuteeName"] as? String,
                                    let  tutorName = channelDict["tutorName"] as? String{
                                    if tuteeName == FIRAuth.auth()?.currentUser?.uid {
                                        print("if channel[self.tutorOrTutee] == FIRAuth.auth()?.currentUser?.uid {")
                                        
                                        if tutorName == destUserID {
                                            self.iterationStatus = "done"
                                            print("perform segue channel")
                                            print(channel)
                                            let newChannel = Channel(id: channel.key, name: "Add Event", tutorName: tutorName, tuteeName: tuteeName)
                                            self.performSegue(withIdentifier: "toAddEventVC", sender: newChannel)
                                            break
                                        }
                                    }
                                }
                                
                            } else if self.currentUserIsTutor == true {
                                if let tuteeName = channelDict["tuteeName"] as? String,
                                    let  tutorName = channelDict["tutorName"] as? String{
                                    if tutorName == FIRAuth.auth()?.currentUser?.uid {
                                        print("if channel[self.tutorOrTutee] == FIRAuth.auth()?.currentUser?.uid {")
                                        if tuteeName == destUserID {
                                            self.iterationStatus = "done"
                                            print("perform segue channel2")
                                            print(channel)
                                            let newChannel = Channel(id: channel.key, name: "Add Event", tutorName: tutorName, tuteeName: tuteeName)
                                            self.performSegue(withIdentifier: "toAddEventVC", sender: newChannel)
                                            break
                                        }
                                    } //if channelDict["tutorName"]
                                }
                            }
                            
                        }
                    } //for channel in allChannels {
                }
                
            } //if snapshot.exists() {
            
            let uuid = UUID().uuidString
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
                    
                    self.performSegue(withIdentifier: "toAddEventVC", sender: channel)
                    
                    
                } else if self.tutorOrTutee == "tutorName" {
                    let channel = Channel(id: uuid, name: "Chat", tutorName: destUserID, tuteeName: (FIRAuth.auth()?.currentUser?.uid)!)
                    print("if tutorOrTutee == tutorName {")
                    
                    print("if self.iterationStatus == inProcess2 {")
                    self.createChannel(otherUser: destUserID)
                    print("perform segue channel4")
                    print(channel)
                    self.performSegue(withIdentifier: "toAddEventVC", sender: channel)
                    
                }
            }
        })
        
        
        
        /*   let channel = channels[(indexPath as NSIndexPath).row]
         print("channel.id")
         print(channel.id)*/
        
        // }
    }
    
    /* func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
     if searchText.isEmpty {
     filteredData = FriendSystem.system.friendList
     } else {
     //If the user has entered text into the search box
     filteredData = FriendSystem.system.friendList.filter({(dataItem: String) -> Bool in
     // If dataItem matches the searchText, return true to include it
     if dataItem.range(ofString: searchText, options: .caseInsensitiveSearch) != nil {
     return true
     } else {
     return false
     }
     })
     }
     self.tableView.reloadData()
     }
     */
    class func instantiateFromStoryboard() -> ChannelListViewController {
        let storyboard = UIStoryboard(name: "MenuViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! ChannelListViewController
    }
    
}



